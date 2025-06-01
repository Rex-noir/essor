package auth

import (
	"context"
	"essor/backend/database"
	"essor/backend/internal/config"
	utils "essor/backend/internal/utils/token"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

// authService is the concrete implementation of the AuthService interface
type authService struct {
	queries *database.Queries
	config  *config.AppConfig
}

// NewAuthService creates a new instance of AuthService
func NewAuthService(q *database.Queries, config *config.AppConfig) AuthService {
	return &authService{
		queries: q,
		config:  config,
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
	accessToken, err := utils.GenerateJWT(createdUser.ID.String(), time.Second*time.Duration(s.config.AccessTokenMaxAge))
	if err != nil {
		log.Printf("Error generating access token for user %s: %v", createdUser.ID.String(), err)
		return nil, fmt.Errorf("failed to generate access token")
	}

	// Generate Refresh Token and store
	refreshToken := utils.GenerateSecureToken(64)
	expiresAt := time.Now().Add(time.Duration(s.config.RefreshTokenMaxAge) * time.Second)

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
	accessToken, err := utils.GenerateJWT(user.ID.String(), time.Duration(s.config.AccessTokenMaxAge)*time.Second)
	if err != nil {
		log.Printf("Error generating access token for user %s during login: %v", user.ID.String(), err)
		return nil, fmt.Errorf("failed to generate access token")
	}

	// Generate Refresh Token and store
	refreshToken := utils.GenerateSecureToken(64)
	expiresAt := time.Now().Add(time.Duration(s.config.RefreshTokenMaxAge) * time.Second) // 7 days

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

func (s *authService) RefreshToken(ctx context.Context, token, userAgent, ipAddress string) (*AuthSuccessResponse, error) {
	stored, err := s.queries.GetRefreshTokenByToken(ctx, token)
	if err != nil || stored.ExpiresAt.Time.Before(time.Now()) {
		log.Printf("Refresh failed: token not found or expired")
		return nil, fmt.Errorf("invalid refresh token")
	}

	user, err := s.queries.GetUserById(ctx, stored.UserID)
	if err != nil {
		log.Printf("Refresh failed: user not found for token %s", token)
		return nil, fmt.Errorf("user not found")
	}

	newAccessToken, err := utils.GenerateJWT(user.ID.String(), time.Duration(s.config.AccessTokenMaxAge)*time.Second)
	if err != nil {
		log.Printf("Refresh failed: could not generate new access token for user %s", user.ID)
		return nil, fmt.Errorf("failed to create new token")
	}

	newRefreshToken := utils.GenerateSecureToken(64)
	expiresAt := time.Now().Add(time.Duration(s.config.RefreshTokenMaxAge) * time.Second)

	_, err = s.queries.CreateRefreshToken(ctx, database.CreateRefreshTokenParams{
		UserID:    user.ID,
		Token:     newRefreshToken,
		UserAgent: pgtype.Text{String: userAgent, Valid: userAgent != ""},
		IpAddress: pgtype.Text{String: ipAddress, Valid: ipAddress != ""},
		ExpiresAt: pgtype.Timestamptz{Time: expiresAt, Valid: true},
	})
	if err != nil {
		log.Printf("Refresh failed: could not store new refresh token for user %s", user.ID)
		return nil, fmt.Errorf("failed to create new refresh token")
	}

	_ = s.queries.DeleteRefreshTokenByToken(ctx, token)

	return &AuthSuccessResponse{
		Data: UserData{
			ID:       user.ID.String(),
			Username: user.Username,
			Email:    user.Email,
		},
		Token:        newAccessToken,
		RefreshToken: newRefreshToken,
	}, nil
}

func (s *authService) SetAuthCookies(ctx *gin.Context, accessToken, refreshToken string) {
	ctx.SetCookie("access_token", accessToken, s.config.AccessTokenMaxAge, "/", s.config.CookieDomain, s.config.CookieSecure, s.config.CookieHTTPOnly)
	ctx.SetCookie("refresh_token", refreshToken, s.config.RefreshTokenMaxAge, "/", s.config.CookieDomain, s.config.CookieSecure, s.config.CookieHTTPOnly)
}

func (s *authService) ClearAuthCookies(ctx *gin.Context) {
	ctx.SetCookie("access_token", "", -1, "/", s.config.CookieDomain, s.config.CookieSecure, s.config.CookieHTTPOnly)
	ctx.SetCookie("refresh_token", "", -1, "/", s.config.CookieDomain, s.config.CookieSecure, s.config.CookieHTTPOnly)
}

func (s *authService) LogoutUser(ctx *gin.Context, deviceId, refreshToken string) error {
	// Expire token
	err := s.queries.ExpireRefreshTokenByTokenWithDeviceId(ctx, database.ExpireRefreshTokenByTokenWithDeviceIdParams{
		Token:    refreshToken,
		DeviceID: deviceId,
	})
	if err != nil {
		return err
	}

	return nil
}
