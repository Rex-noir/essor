package utils

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GenerateSecureToken(length int) string {
	bytes := make([]byte, length)
	_, err := rand.Read(bytes)
	if err != nil {
		panic("failed to generate secure token") // or log and handle differently
	}
	return hex.EncodeToString(bytes)
}

func GenerateJWT(userID string, duration time.Duration) (string, error) {

	if userID == "" {
		return "", fmt.Errorf("userID cannot be empty")
	}

	if duration <= 0 {
		return "", fmt.Errorf("duration must be positive")
	}

	secret := os.Getenv("JWT_SECRET_KEY")
	if secret == "" {
		return "", fmt.Errorf("JWT_SECRET_KEY environment variable not set or empty")
	}

	claims := jwt.MapClaims{
		"sub": userID,                          // Subject (standard claim) - identifies the principal that is the subject of the JWT.
		"exp": time.Now().Add(duration).Unix(), // Expiration Time (standard claim) - identifies the expiration time on or after which the JWT MUST NOT be accepted for processing.
		"iat": time.Now().Unix(),               // Issued At (standard claim) - identifies the time at which the JWT was issued.
		// "iss": "your-application-name",         // Issuer (optional standard claim) - identifies the principal that issued the JWT.
		// "aud": "your-intended-audience",        // Audience (optional standard claim) - identifies the recipients that the JWT is intended for.
		// "nbf": time.Now().Add(time.Minute).Unix(), // Not Before (optional standard claim) - identifies the time before which the JWT MUST NOT be accepted for processing.
		// You can add more custom claims as needed, e.g.:
		// "role": "user",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	signedToken, err := token.SignedString([]byte(secret))
	if err != nil {
		// It's good practice to wrap errors to provide more context
		// without losing the original error information.
		return "", fmt.Errorf("failed to sign token: %w", err)
	}

	return signedToken, nil

}

func VerifyJWT(tokenStr string) (string, error) {
	secret := os.Getenv("JWT_SECRET_KEY")

	if secret == "" {
		return "", fmt.Errorf("JWT_SECRET_KEY environment variable not set or empty")
	}

	token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (any, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}

		return []byte(secret), nil
	})

	if err != nil {
		return "", fmt.Errorf("failed to parse or verify token: %w", err)
	}
	if !token.Valid {
		return "", fmt.Errorf("token is invalid")
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return "", fmt.Errorf("invalid token claims")
	}

	sub, ok := claims["sub"].(string)
	if !ok || sub == "" {
		return "", fmt.Errorf("token does not contain a valid 'sub' claim")
	}

	return sub, nil

}
