CREATE TABLE IF NOT EXISTS habit_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    habit_id UUID NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    entry_date DATE NOT NULL,
    completed BOOLEAN DEFAULT false,
    value DECIMAL(10,2),
    notes TEXT,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE NULL, -- soft delete for sync
    sync_version BIGINT DEFAULT 1,

    UNIQUE(habit_id, entry_date, user_id)
)
---- create above / drop below ----
DROP TABLE IF EXISTS habit_entries;
