package habit_category

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type CreateCategoryRequest struct {
	UserID string `json:"user_id" binding:"required,uuid"`
	Name   string `json:"name" binding:"required"`
	Color  string `json:"color" binding:"omitempty,len=7"` // e.g. "#FF0000"
}

type UpdateCategoryRequest struct {
	ID    string `json:"id" binding:"required,uuid"`
	Name  string `json:"name" binding:"required"`
	Color string `json:"color" binding:"omitempty,len=7"`
}

type DeleteCategoryRequest struct {
	ID string `json:"id" binding:"required,uuid"`
}

type CategoryResponse struct {
	ID          string     `json:"id"`
	UserID      string     `json:"user_id"`
	Name        string     `json:"name"`
	Color       string     `json:"color,omitempty"`
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`
	DeletedAt   *time.Time `json:"deleted_at,omitempty"`
	SyncVersion int64      `json:"sync_version"`
}
type CategoryService interface {
	CreateCategory(ctx context.Context, req CreateCategoryRequest) (*CategoryResponse, error)
	GetCategory(ctx context.Context, id string) (*CategoryResponse, error)
	UpdateCategory(ctx context.Context, req UpdateCategoryRequest, userId string) (*CategoryResponse, error)
	DeleteCategory(ctx context.Context, id string) error
	ListCategories(ctx context.Context, userID string) ([]CategoryResponse, error)
}

func RegisterRoutes(r *gin.RouterGroup, service CategoryService) {
	route := r.Group("categories")

	route.PUT("/", updateHandler(service))
	route.POST("/", createHandler(service))
	route.GET("/", indexHandler(service))
	route.DELETE("/:id", deleteHanlder(service))

}

func createHandler(service CategoryService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req CreateCategoryRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(400, gin.H{"message": "invalid input"})
			return
		}

		createdCategory, err := service.CreateCategory(ctx, req)
		if err != nil {
			ctx.JSON(500, gin.H{"message": "failed to create category"})
			return
		}

		ctx.JSON(http.StatusCreated, gin.H{"data": createdCategory})
	}
}

func updateHandler(service CategoryService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req UpdateCategoryRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(http.StatusUnprocessableEntity, gin.H{"message": "invalid input"})
			return
		}

		updatedCategory, err := service.UpdateCategory(ctx, req, ctx.GetString("userId"))
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"message": "failed to update category"})
			return
		}
		ctx.JSON(http.StatusOK, gin.H{"data": updatedCategory})
	}
}

func indexHandler(service CategoryService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		allCategories, err := service.ListCategories(ctx, ctx.GetString("userId"))
		if err != nil {
			ctx.JSON(http.StatusUnauthorized, gin.H{"message": "User ID not found"})
			return
		}
		ctx.JSON(http.StatusOK, allCategories)
	}
}

func deleteHanlder(service CategoryService) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		id := ctx.Param("id")

		if id == "" {
			ctx.JSON(http.StatusBadRequest, gin.H{"message": "missing id"})
			return
		}

		err := service.DeleteCategory(ctx, id)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"message": "failed to delete category"})
			return
		}

		ctx.JSON(http.StatusOK, gin.H{"message": "category deleted"})
	}
}
