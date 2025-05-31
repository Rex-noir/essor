package tests

import (
	"bytes"
	"encoding/json"
	"essor/backend/api/auth"
	"essor/backend/database"

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

func setUpRouter(q *database.Queries) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.Default()

	api := r.Group("/api")

	auth.RegisterRoutes(api, auth.NewAuthService(q))

	return r
}

var testQueries *database.Queries

func TestMain(m *testing.M) {
	testQueries = testutils.SetupTestDB()
	m.Run()
}

func TestRegisterAndLoginFlow(t *testing.T) {

	router := setUpRouter(testQueries)
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
