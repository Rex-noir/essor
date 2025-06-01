package tests

import (
	"bytes"
	"encoding/json"
	"essor/backend/api/auth"
	"essor/backend/database"
	"essor/backend/internal/config"
	testutils "essor/backend/internal/utils/test-utils"

	"fmt"
	"log"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var (
	testQueries *database.Queries
	router      *gin.Engine
	api         *gin.RouterGroup
)

func TestMain(m *testing.M) {
	testQueries = testutils.SetupTestDB()
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}
	router, api = testutils.NewApiRouter()
	auth.RegisterRoutes(api, auth.NewAuthService(testQueries, cfg))
	m.Run()
}

func TestRegisterAndLoginFlow(t *testing.T) {

	email := fmt.Sprintf("user%d@example.com", time.Now().UnixNano())

	registerPayload := auth.RegisterRequest{
		Email:    email,
		Password: "password",
		Username: "testuser",
	}

	jsonData, err := json.Marshal(registerPayload)
	if err != nil {
		log.Fatalf("Failed to marshal JSON payload: %v", err)
	}

	req := httptest.NewRequest(http.MethodPost, "/api/auth/register", bytes.NewReader(jsonData))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var regResp auth.AuthSuccessResponse
	err = json.Unmarshal(w.Body.Bytes(), &regResp)
	assert.NoError(t, err)
	assert.Equal(t, "testuser", regResp.Data.Username)
	assert.Equal(t, email, regResp.Data.Email)
	assert.NotEmpty(t, regResp.Token)
	assert.NotEmpty(t, regResp.RefreshToken)
	assert.NotEmpty(t, regResp.DeviceID)

	loginPayload := map[string]string{
		"email":    email,
		"password": "password",
	}
	body, _ := json.Marshal(loginPayload)
	req = httptest.NewRequest(http.MethodPost, "/api/auth/login", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w = httptest.NewRecorder()

	router.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)

	var loginResp auth.AuthSuccessResponse
	err = json.Unmarshal(w.Body.Bytes(), &loginResp)
	assert.NoError(t, err)
	assert.Equal(t, email, loginResp.Data.Email)
	assert.NotEmpty(t, loginResp.Token)
	assert.NotEmpty(t, loginResp.RefreshToken)

	badLoginPayload := map[string]string{
		"email":    email,
		"password": "wrongpass",
	}
	body, _ = json.Marshal(badLoginPayload)
	req = httptest.NewRequest(http.MethodPost, "/api/auth/login", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w = httptest.NewRecorder()

	router.ServeHTTP(w, req)
	assert.Equal(t, http.StatusUnauthorized, w.Code)

}

func TestRefreshTokenFlow(t *testing.T) {
	email := fmt.Sprintf("user%d@example.com", time.Now().UnixNano())
	registerPayload := auth.RegisterRequest{
		Email:    email,
		Password: "password",
		Username: "testuser",
	}

	jsonData, err := json.Marshal(registerPayload)
	if err != nil {
		log.Fatalf("Failed to marshal JSON payload: %v", err)
	}
	req := httptest.NewRequest(http.MethodPost, "/api/auth/register", bytes.NewReader(jsonData))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	var registerResponse auth.AuthSuccessResponse
	err = json.Unmarshal(w.Body.Bytes(), &registerResponse)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusCreated, w.Code)
	assert.Equal(t, "testuser", registerResponse.Data.Username)

	// refresh token inside database
	refreshToken := registerResponse.RefreshToken
	storedRefreshToken, err := testQueries.GetRefreshTokenByTokenAndDeviceId(req.Context(), database.GetRefreshTokenByTokenAndDeviceIdParams{
		Token:    refreshToken,
		DeviceID: registerResponse.DeviceID,
	})
	if err != nil {
		log.Fatalf("Failed to get refresh token: %v", err)
	}
	assert.Equal(t, refreshToken, storedRefreshToken.Token)

	// refresh the token and make sure the new token is not the same
	var refreshResponse auth.AuthSuccessResponse
	req = httptest.NewRequest(http.MethodPost, "/api/auth/refresh", nil)
	req.Header.Set("Content-Type", "application/json")

	req.Header.Set("Authorization", "Bearer "+refreshToken)
	req.Header.Set("Device-ID", registerResponse.DeviceID)
	w = httptest.NewRecorder()
	router.ServeHTTP(w, req)

	err = json.Unmarshal(w.Body.Bytes(), &refreshResponse)
	assert.NoError(t, err)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.NotEqual(t, refreshToken, refreshResponse.RefreshToken)

	// Make sure old token is not still inside database
	result, err := testQueries.GetRefreshTokenByToken(req.Context(), refreshToken)
	assert.Error(t, err)
	assert.Empty(t, result)

}
