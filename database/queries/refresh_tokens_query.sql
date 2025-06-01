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

-- name: ExpireRefreshTokenByTokenWithDevceId :exec
UPDATE refresh_tokens
SET expires_at = NOW()
WHERE token = $1 AND device_id = $2;

-- name: GetRefreshTokenByTokenAndDeviceId :one
SELECT * FROM refresh_tokens
WHERE token = $1 AND device_id = $2;

-- name: DeleteRefreshTokenByTokenAndDeviceId :exec
DELETE FROM refresh_tokens
WHERE token = $1 AND device_id = $2;

-- name: ListRefreshTokensByUserAndDeviceId :many
SELECT * FROM refresh_tokens
WHERE user_id = $1 AND device_id = $2
ORDER BY created_at DESC;

-- name: ExpireRefreshTokensByDeviceId :exec
UPDATE refresh_tokens
SET expires_at = NOW()
WHERE device_id = $1;

-- name: DeleteRefreshTokensByDeviceId :exec
DELETE FROM refresh_tokens
WHERE device_id = $1;

-- name: RevokeAllTokensExceptDeviceId :exec
DELETE FROM refresh_tokens
WHERE user_id = $1 AND device_id != $2;

-- name: ExpireAllTokensExceptDeviceId :exec
UPDATE refresh_tokens
SET expires_at = NOW()
WHERE user_id = $1 AND device_id != $2;
