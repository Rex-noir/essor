package auth

import (
	"fmt"
	"habit_tracker/api/database"
	utils "habit_tracker/api/internal/tokens"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgtype"
	"golang.org/x/crypto/bcrypt"
)

type RegisterRequest struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required, email"`
	Password string `json:"password" binding:"required, min=6"`
}

type UserData struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}

type AuthSuccessResponse struct {
	Data         UserData `json:"data"`
	Token        string   `json:"token,omitempty"`
	RefreshToken string   `json:"refresh_token,omitempty"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

func RegisterRoutes(r *gin.RouterGroup, q *database.Queries) {
	route := r.Group("/auth")

	route.POST("/login", func(ctx *gin.Context) {

	})

	route.POST("/register", func(ctx *gin.Context) {
		var req RegisterRequest

		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
			return
		}

		req.Username = strings.TrimSpace(req.Username)
		req.Email = strings.ToLower(strings.TrimSpace(req.Email))

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "could not hash password"})
			return
		}

		// Create User
		createdUser, err := q.CreateUser(ctx.Request.Context(), database.CreateUserParams{
			Username: req.Username, Email: req.Email, Password: string(hashedPassword)})

		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create user"})
			return
		}

		accessToken, err := utils.GenerateJWT(createdUser.ID.String(), time.Minute*15)
		if err != nil {
			// Log the error for debugging purposes (e.g., with fmt.Errorf or a logger)
			fmt.Printf("Error generating access token for user %s: %v\n", createdUser.ID.String(), err)
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate access token"})
			return
		}

		refreshToken := utils.GenerateSecureToken(64)
		if err != nil {
			// Log the error
			fmt.Printf("Error generating refresh token for user %s: %v\n", createdUser.ID.String(), err)
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate refresh token"})
			return
		}

		userAgent := ctx.GetHeader("User-Agent")
		ipAddress := ctx.ClientIP()
		expiresAt := time.Now().Add(7 * 24 * time.Hour)

		params := database.CreateRefreshTokenParams{
			UserID:    createdUser.ID,
			Token:     refreshToken,
			UserAgent: pgtype.Text{String: userAgent, Valid: userAgent != ""}, // assuming nullable columns, use pointers
			IpAddress: pgtype.Text{String: ipAddress, Valid: ipAddress != ""},
			ExpiresAt: pgtype.Timestamptz{Time: expiresAt, Valid: true},
		}
		// Store refresh token inside database
		createdRefreshToken, err := q.CreateRefreshToken(ctx.Request.Context(), params)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create refresh token"})
			return
		}

		ctx.JSON(http.StatusCreated, AuthSuccessResponse{
			Data: UserData{
				ID:       createdUser.ID.String(),
				Username: createdUser.Username,
				Email:    createdUser.Email,
			},
			Token:        accessToken,
			RefreshToken: createdRefreshToken.Token,
		})

	})
}
