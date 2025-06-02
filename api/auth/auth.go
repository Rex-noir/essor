package auth

import (
	"context"
	"log"
	"net/http"
	"strings"

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
	DeviceID     string   `json:"device_id,omitempty"`
}

type AuthService interface {
	RegisterUser(ctx context.Context, req RegisterRequest, userAgent, ipAddress string) (*AuthSuccessResponse, error)
	LoginUser(ctx context.Context, req LoginRequest, userAgent, ipAddress string, deviceId string) (*AuthSuccessResponse, error)
	RefreshToken(ctx context.Context, token, userAgent, ipAddress string, deviceId string) (*AuthSuccessResponse, error)
	SetAuthCookies(ctx *gin.Context, token, refreshToken string)
	ClearAuthCookies(ctx *gin.Context)
	LogoutUser(ctx *gin.Context, deviceId, refreshToken string) error
}

func RegisterRoutes(r *gin.RouterGroup, service AuthService) { // Now takes an AuthService interface
	route := r.Group("/auth")

	route.POST("/login", loginHandler(service))
	route.POST("/register", registerHandler(service))
	route.POST("/refresh", refreshHandler(service))
	route.POST("/logout", logoutHandler(service))

}

func loginHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req LoginRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"message": "invalid input"})
			return
		}

		resp, err := service.LoginUser(
			ctx.Request.Context(),
			req,
			ctx.GetHeader("User-Agent"),
			ctx.ClientIP(),
			ctx.GetHeader("Device-ID"),
		)

		if err != nil {
			if err.Error() == "invalid credentials" {
				ctx.JSON(http.StatusUnauthorized, gin.H{"message": "invalid email or password"})
			} else {
				ctx.JSON(http.StatusInternalServerError, gin.H{"message": "failed to log in"})
			}
			return
		}

		service.SetAuthCookies(ctx, resp.Token, resp.RefreshToken)

		ctx.JSON(http.StatusOK, resp)
	}
}

func registerHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req RegisterRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"message": "invalid input"})
			return
		}

		resp, err := service.RegisterUser(
			ctx.Request.Context(),
			req,
			ctx.GetHeader("User-Agent"),
			ctx.ClientIP(),
		)

		if err != nil {
			if err.Error() == "user already exists" {
				ctx.JSON(http.StatusConflict, gin.H{"message": "user with this email or username already exists"})
			} else {
				ctx.JSON(http.StatusInternalServerError, gin.H{"message": "failed to register user"})
			}
			return
		}

		service.SetAuthCookies(ctx, resp.Token, resp.RefreshToken)

		ctx.JSON(http.StatusCreated, resp)
	}
}

func refreshHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		refreshToken, err := ctx.Cookie("refresh_token")
		if err != nil || refreshToken == "" {
			refreshToken = ctx.GetHeader("X-Refresh-Token")
			if refreshToken == "" {
				ctx.JSON(http.StatusUnauthorized, gin.H{"message": "missing or invalid refresh token"})
				return
			}
		}
		refreshToken = strings.TrimPrefix(refreshToken, "Bearer ")

		resp, err := service.RefreshToken(ctx.Request.Context(), refreshToken, ctx.GetHeader("User-Agent"), ctx.ClientIP(), ctx.GetHeader("Device-ID"))
		if err != nil {
			log.Printf("Error refreshing token: %v", err)
			ctx.JSON(http.StatusUnauthorized, gin.H{"message": "invalid refresh token"})
			return
		}

		ctx.JSON(http.StatusOK, resp)
	}
}

func logoutHandler(service AuthService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		refreshToken, err := ctx.Cookie("refresh_token")
		if err != nil || refreshToken == "" {
			ctx.JSON(http.StatusUnauthorized, gin.H{"message": "missing or invalid refresh token"})
			return
		}

		deviceId := ctx.GetHeader("Device-ID")
		if deviceId == "" {
			ctx.JSON(http.StatusBadRequest, gin.H{"message": "missing device ID"})
			return
		}

		err = service.LogoutUser(ctx, deviceId, refreshToken)
		if err != nil {
			ctx.JSON(http.StatusUnauthorized, gin.H{"message": "invalid refresh token"})
			return
		} else {
			service.ClearAuthCookies(ctx)
		}

		ctx.JSON(http.StatusOK, gin.H{"message": "successfully logged out"})
	}
}
