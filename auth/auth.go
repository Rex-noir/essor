package auth

import (
	"context"
	"net/http"

	// Only needed for time.Minute/Hour constants for JWT generation
	"github.com/gin-gonic/gin"
	// Still needed for database params, but encapsulated in service
)

// Define common structs for request/response bodies
type RegisterRequest struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
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

// Define the AuthService interface
// This specifies the contract for our authentication business logic
type AuthService interface {
	RegisterUser(ctx context.Context, req RegisterRequest, userAgent, ipAddress string) (*AuthSuccessResponse, error)
	LoginUser(ctx context.Context, req LoginRequest, userAgent, ipAddress string) (*AuthSuccessResponse, error)
	// Add other methods as your auth needs grow, e.g., Logout, RefreshToken, ForgotPassword etc.
}

// RegisterRoutes sets up the authentication API endpoints
func RegisterRoutes(r *gin.RouterGroup, service AuthService) { // Now takes an AuthService interface
	route := r.Group("/auth")

	route.POST("/login", loginHandler(service))
	route.POST("/register", registerHandler(service))
}

// loginHandler is the Gin handler for user login
func loginHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req LoginRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
			return
		}

		// Call the service layer for business logic
		resp, err := service.LoginUser(
			ctx.Request.Context(), // Use the request context
			req,
			ctx.GetHeader("User-Agent"),
			ctx.ClientIP(),
		)

		if err != nil {
			// Translate service errors to HTTP responses
			// You might want to define custom error types in your service
			// to return more specific HTTP status codes (e.g., ErrNotFound, ErrInvalidCredentials)
			if err.Error() == "invalid credentials" { // Example: match specific service error
				ctx.JSON(http.StatusUnauthorized, gin.H{"error": "invalid email or password"})
			} else {
				ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to log in"})
			}
			return
		}

		ctx.JSON(http.StatusOK, resp)
	}
}

// registerHandler is the Gin handler for user registration
func registerHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req RegisterRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid input"})
			return
		}

		// Call the service layer for business logic
		resp, err := service.RegisterUser(
			ctx.Request.Context(), // Use the request context
			req,
			ctx.GetHeader("User-Agent"),
			ctx.ClientIP(),
		)

		if err != nil {
			// Translate service errors to HTTP responses
			if err.Error() == "user already exists" { // Example: match specific service error
				ctx.JSON(http.StatusConflict, gin.H{"error": "user with this email or username already exists"})
			} else {
				ctx.JSON(http.StatusInternalServerError, gin.H{"error": "failed to register user"})
			}
			return
		}

		ctx.JSON(http.StatusCreated, resp)
	}
}
