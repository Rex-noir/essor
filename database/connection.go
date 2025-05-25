package database

import (
	"context"
	"fmt"
	"log"

	"github.com/jackc/pgx/v5/pgxpool"
)

func ConnectDB(ctx context.Context, connString string) (*pgxpool.Pool, error) {
	log.Printf("Attempting to connect to database using connection string...")

	dbPool, err := pgxpool.New(ctx, connString)

	if err != nil {
		return nil, fmt.Errorf("failed to connect to DB: %w", err)
	}

	if err = dbPool.Ping(ctx); err != nil {
		dbPool.Close()
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	log.Println("Successfully connected to the database!")
	return dbPool, nil
}
