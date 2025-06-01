-- name: CreateCategory :one
INSERT INTO habit_categories (
    user_id, name, color
)
VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: GetHabitCategory :one 
SELECT * FROM  habit_categories
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateHabitCategory :one
UPDATE habit_categories
SET name = $2,
    color = $3
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: DeleteHabitCategory :exec
UPDATE habit_categories
SET deleted_at = NOW()
WHERE id = $1;

-- name: ListHabitCategoriesByUser :many
SELECT * FROM habit_categories
WHERE user_id = $1 AND deleted_at IS NUll
ORDER BY created_at DESC;

-- name: UpsertCategory :one
INSERT INTO habit_categories (
    user_id, name, color, id
)
VALUES ($1, $2, $3, $4)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    color = EXCLUDED.color
RETURNING *;