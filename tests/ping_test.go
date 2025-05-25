package tests

import (
	"habit_tracker/api/ping"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestPingRoute(t *testing.T) {
	r := gin.Default()

	api := r.Group("/api")

	ping.RegisterRoutes(api)

	req, _ := http.NewRequest("GET", "/api/ping", nil)

	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", w.Code)
	}

	expected := "pong"
	if w.Body.String() != expected {
		t.Errorf("Expected response body %s, got %s", expected, w.Body.String())
	}
}
