-- name: CreateRefreshToken :one
INSERT INTO refresh_tokens (
    user_id, token, user_agent, ip_address, expires_at
) VALUES (
    $1, $2, $3, $4, $5
)
RETURNING *;

-- name: GetRefreshTokenByToken :one
SELECT * FROM refresh_tokens
WHERE token = $1;

-- name: ListRefreshTokensByUser :many
SELECT * FROM refresh_tokens
WHERE user_id = $1
ORDER BY created_at DESC;

-- name: DeleteRefreshTokenByToken :exec
DELETE FROM refresh_tokens
WHERE token = $1;

-- name: DeleteRefreshTokensByUserID :exec
DELETE FROM refresh_tokens
WHERE user_id = $1;

-- name: DeleteExpiredRefreshTokens :exec
DELETE FROM refresh_tokens
WHERE expires_at < now();