-- name: GetUserById :one
SELECT * FROM users
WHERE  id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY created_at;

-- name: CreateUser :one
INSERT INTO users (
    username, email, password
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: GetUserByEmail :one
SELECT id, email, password, created_at
FROM users
WHERE email = $1;