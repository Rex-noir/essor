package auth

import (
	"context"
	"essor/backend/database"
	utils "essor/backend/internal/utils/token"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

// authService is the concrete implementation of the AuthService interface
type authService struct {
	queries *database.Queries
}

// NewAuthService creates a new instance of AuthService
func NewAuthService(q *database.Queries) AuthService {
	return &authService{
		queries: q,
	}
}

// RegisterUser handles the business logic for user registration
func (s *authService) RegisterUser(ctx context.Context, req RegisterRequest, userAgent, ipAddress string) (*AuthSuccessResponse, error) {
	req.Username = strings.TrimSpace(req.Username)
	req.Email = strings.ToLower(strings.TrimSpace(req.Email))

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("Error hashing password for user %s: %v", req.Email, err)
		return nil, fmt.Errorf("could not hash password")
	}

	// Create User in DB
	createdUser, err := s.queries.CreateUser(ctx, database.CreateUserParams{
		Username: req.Username,
		Email:    req.Email,
		Password: string(hashedPassword),
	})
	if err != nil {
		// You might check for specific pgx errors here (e.g., unique constraint violation)
		// For example, if you know pgx returns a specific error for unique constraint:
		// if pgErr, ok := err.(*pgconn.PgError); ok && pgErr.Code == "23505" { // 23505 is unique_violation
		//     return nil, fmt.Errorf("user already exists")
		// }
		log.Printf("Error creating user %s: %v", req.Email, err)
		return nil, fmt.Errorf("failed to create user")
	}

	// Generate Access Token
	accessToken, err := utils.GenerateJWT(createdUser.ID.String(), time.Minute*15)
	if err != nil {
		log.Printf("Error generating access token for user %s: %v", createdUser.ID.String(), err)
		return nil, fmt.Errorf("failed to generate access token")
	}

	// Generate Refresh Token and store
	refreshToken := utils.GenerateSecureToken(64)
	expiresAt := time.Now().Add(7 * 24 * time.Hour) // 7 days

	refreshTokenParams := database.CreateRefreshTokenParams{
		UserID:    createdUser.ID,
		Token:     refreshToken,
		UserAgent: pgtype.Text{String: userAgent, Valid: userAgent != ""},
		IpAddress: pgtype.Text{String: ipAddress, Valid: ipAddress != ""},
		ExpiresAt: pgtype.Timestamptz{Time: expiresAt, Valid: true},
	}
	_, err = s.queries.CreateRefreshToken(ctx, refreshTokenParams)
	if err != nil {
		log.Printf("Error creating refresh token for user %s: %v", createdUser.ID.String(), err)
		return nil, fmt.Errorf("failed to create refresh token")
	}

	return &AuthSuccessResponse{
		Data: UserData{
			ID:       createdUser.ID.String(),
			Username: createdUser.Username,
			Email:    createdUser.Email,
		},
		Token:        accessToken,
		RefreshToken: refreshToken,
	}, nil
}

// LoginUser handles the business logic for user login
func (s *authService) LoginUser(ctx context.Context, req LoginRequest, userAgent, ipAddress string) (*AuthSuccessResponse, error) {
	req.Email = strings.ToLower(strings.TrimSpace(req.Email))
	req.Password = strings.TrimSpace(req.Password)

	// Get user by email
	user, err := s.queries.GetUserByEmail(ctx, req.Email)
	if err != nil {
		// Consider checking for database.ErrNoRows here to return "invalid credentials" more specifically
		// For now, generic log and error
		log.Printf("Login failed for email %s: User not found or DB error: %v", req.Email, err)
		return nil, fmt.Errorf("invalid credentials")
	}

	// Verify password
	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if err != nil {
		log.Printf("Login failed for email %s: Password mismatch: %v", req.Email, err)
		return nil, fmt.Errorf("invalid credentials")
	}

	// Generate Access Token
	accessToken, err := utils.GenerateJWT(user.ID.String(), time.Minute*5)
	if err != nil {
		log.Printf("Error generating access token for user %s during login: %v", user.ID.String(), err)
		return nil, fmt.Errorf("failed to generate access token")
	}

	// Generate Refresh Token and store
	refreshToken := utils.GenerateSecureToken(64)
	expiresAt := time.Now().Add(7 * 24 * time.Hour) // 7 days

	refreshTokenParams := database.CreateRefreshTokenParams{
		UserID:    user.ID,
		Token:     refreshToken,
		UserAgent: pgtype.Text{String: userAgent, Valid: userAgent != ""},
		IpAddress: pgtype.Text{String: ipAddress, Valid: ipAddress != ""},
		ExpiresAt: pgtype.Timestamptz{Time: expiresAt, Valid: true},
	}
	_, err = s.queries.CreateRefreshToken(ctx, refreshTokenParams)
	if err != nil {
		log.Printf("Error creating refresh token for user %s during login: %v", user.ID.String(), err)
		return nil, fmt.Errorf("failed to create refresh token")
	}

	return &AuthSuccessResponse{
		Data: UserData{
			ID:       user.ID.String(),
			Username: user.Username,
			Email:    user.Email,
		},
		Token:        accessToken,
		RefreshToken: refreshToken,
	}, nil
}
