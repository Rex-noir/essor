package habit_category

import (
	"context"
	"essor/backend/database"

	"github.com/jackc/pgx/v5/pgtype"
)

type categoryService struct {
	queries *database.Queries
}

func NewCategoryService(q *database.Queries) CategoryService {
	return &categoryService{queries: q}
}

func (s *categoryService) CreateCategory(ctx context.Context, req CreateCategoryRequest) (*CategoryResponse, error) {
	var uuid pgtype.UUID
	if err := uuid.Scan(req.UserID); err != nil {
		return nil, err
	}

	var color pgtype.Text
	if err := color.Scan(req.Color); err != nil {
		return nil, err
	}

	dbCat, err := s.queries.CreateCategory(ctx, database.CreateCategoryParams{
		UserID: uuid,
		Name:   req.Name,
		Color:  color,
	})
	if err != nil {
		return nil, err
	}
	return toCategoryResponse(dbCat), nil
}

func (s *categoryService) GetCategory(ctx context.Context, id string) (*CategoryResponse, error) {
	var uuid pgtype.UUID
	if err := uuid.Scan(id); err != nil {
		return nil, err
	}

	dbCat, err := s.queries.GetHabitCategory(ctx, uuid)
	if err != nil {
		return nil, err
	}
	return toCategoryResponse(dbCat), nil
}

func (s *categoryService) UpdateCategory(ctx context.Context, req UpdateCategoryRequest, userID string) (*CategoryResponse, error) {
	// You might want to check the category exists or belongs to user here
	var uuid pgtype.UUID
	if err := uuid.Scan(req.ID); err != nil {
		return nil, err
	}

	var user pgtype.UUID
	if err := user.Scan(userID); err != nil {
		return nil, err
	}

	var color pgtype.Text
	if err := color.Scan(req.Color); err != nil {
		return nil, err
	}
	updatedCat, err := s.queries.UpsertCategory(ctx, database.UpsertCategoryParams{
		ID:     uuid,
		Name:   req.Name,
		Color:  color,
		UserID: user,
	})
	if err != nil {
		return nil, err
	}
	return toCategoryResponse(updatedCat), nil
}

func (s *categoryService) DeleteCategory(ctx context.Context, id string) error {
	var uuid pgtype.UUID
	if err := uuid.Scan(id); err != nil {
		return err
	}
	return s.queries.DeleteHabitCategory(ctx, uuid)
}

func (s *categoryService) ListCategories(ctx context.Context, userID string) ([]CategoryResponse, error) {
	var uuid pgtype.UUID
	if err := uuid.Scan(userID); err != nil {
		return nil, err
	}
	dbCats, err := s.queries.ListHabitCategoriesByUser(ctx, uuid)
	if err != nil {
		return nil, err
	}
	resp := make([]CategoryResponse, len(dbCats))
	for i, c := range dbCats {
		resp[i] = *toCategoryResponse(c)
	}
	return resp, nil
}

// Helper to map DB model to response
func toCategoryResponse(dbCat database.HabitCategory) *CategoryResponse {
	return &CategoryResponse{
		ID:          dbCat.ID.String(),
		UserID:      dbCat.UserID.String(),
		Name:        dbCat.Name,
		Color:       dbCat.Color.String,
		CreatedAt:   dbCat.CreatedAt.Time,
		UpdatedAt:   dbCat.UpdatedAt.Time,
		DeletedAt:   &dbCat.DeletedAt.Time,
		SyncVersion: dbCat.SyncVersion.Int64,
	}
}
