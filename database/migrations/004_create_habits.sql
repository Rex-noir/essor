CREATE TABLE IF NOT EXISTS habits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    title VARCHAR(100) NOT NULL,
    description TEXT,

    habit_type VARCHAR(20) NOT NULL CHECK(habit_type IN ('binary', 'quantitative')),

    unit VARCHAR(20),
    target_value DECIMAL(10,2),
    target_operator VARCHAR(10) CHECK (target_operator IN ('>=', '<=', '=')),

    frequency VARCHAR(20) DEFAULT 'daily' CHECK (frequency IN ('daily', 'weekly', 'monthly')),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL
    weekly_days INTEGER[] DEFAULT '{}',
    monthly_dates INTEGER[] DEFAULT '{}',
    interval INTEGER NOT NULL DEFAULT 1 CHECK (interval >= 1)

    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    sync_version BIGINT DEFAULT 1
)
---- create above / drop below ----
DROP TABLE IF EXISTS habits;
