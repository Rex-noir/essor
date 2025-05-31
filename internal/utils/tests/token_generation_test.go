package utils

import (
	"essor/backend/internal/utils"
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/stretchr/testify/assert"
)

func TestGenerateJWT(t *testing.T) {
	testSecret := "test-secret-key-that-is-long-enough"
	assert := assert.New(t)

	os.Setenv("JWT_SECRET_KEY", testSecret)

	defer os.Unsetenv("JWT_SECRET_KEY")

	userId := "user123"
	duration := time.Hour

	tokenStr, err := utils.GenerateJWT(userId, duration)

	assert.NoError(err)
	assert.NotEmpty(tokenStr)

	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			t.Fatalf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(testSecret), nil
	})

	assert.NoError(err)
	assert.True(token.Valid)

	claims, ok := token.Claims.(jwt.MapClaims)
	assert.True(ok)

	fmt.Printf("Claims %#v\n", claims)

	assert.Equal(userId, claims["sub"])
	assert.Greater(int64(claims["exp"].(float64)), time.Now().Unix())
	assert.LessOrEqual(int64(claims["iat"].(float64)), time.Now().Unix())

}

func TestGenerateJWT_ExpiredToken(t *testing.T) {
	testSecret := "test-secret-key-that-is-long-enough"
	assert := assert.New(t)

	os.Setenv("JWT_SECRET_KEY", testSecret)
	defer os.Unsetenv("JWT_SECRET_KEY")

	userId := "user123"
	duration := time.Second // token expires in 1 second

	tokenStr, err := utils.GenerateJWT(userId, duration)
	assert.NoError(err)
	assert.NotEmpty(tokenStr)

	// Wait for token to expire
	time.Sleep(2 * time.Second)

	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			t.Fatalf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(testSecret), nil
	})

	// The token should be expired and thus invalid
	assert.Error(err)
	assert.Contains(err.Error(), "token is expired")
	assert.False(token.Valid)
}

func TestVerifyJWT(t *testing.T) {
	testSecret := "test-secret-key-that-is-long-enough"
	os.Setenv("JWT_SECRET_KEY", testSecret)
	defer os.Unsetenv("JWT_SECRET_KEY")

	assert := assert.New(t)
	userId := "user123"

	t.Run("Valid token", func(t *testing.T) {
		tokenStr, err := utils.GenerateJWT(userId, time.Hour)
		assert.NoError(err)
		assert.NotEmpty(tokenStr)

		verifiedUserId, err := utils.VerifyJWT(tokenStr)
		assert.NoError(err)
		assert.Equal(userId, verifiedUserId)
	})

	t.Run("expired tokens", func(t *testing.T) {
		tokenStr, err := utils.GenerateJWT(userId, time.Second)
		assert.NoError(err)
		assert.NotEmpty(tokenStr)

		time.Sleep(2 * time.Second)

		verifiedUserId, err := utils.VerifyJWT(tokenStr)
		assert.Error(err)
		assert.Contains(err.Error(), "token is expired")
		assert.Empty(verifiedUserId)
	})

	t.Run("tampered token", func(t *testing.T) {
		// Generate a valid token
		tokenStr, err := utils.GenerateJWT(userId, time.Hour)
		assert.NoError(err)
		assert.NotEmpty(tokenStr)

		// Tamper the token by changing one character (simulate invalid signature)
		tamperedToken := tokenStr[:len(tokenStr)-1] + "X"

		verifiedUserId, err := utils.VerifyJWT(tamperedToken)
		assert.Error(err)
		assert.Contains(err.Error(), "signature is invalid")
		assert.Empty(verifiedUserId)
	})
}
