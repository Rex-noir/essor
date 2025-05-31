CREATE TABLE IF NOT EXISTS habits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES habit_categories(id) ON DELETE SET NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,

    habit_type VARCHAR(20) NOT NULL CHECK(habit_type IN ('boolean', 'numeric', 'duration')),

    unit VARCHAR(20),
    target_value DECIMAL(10,2),
    target_operator VARCHAR(10) CHECK (target_operator IN ('>=', '<=', '=')),

    frequency VARCHAR(20) DEFAULT 'daily' CHECK (frequency IN ('daily', 'weekly', 'monthly')),
    active_days INTEGER[] DEFAULT '{1,2,3,4,5,6,7}',

    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    sync_version BIGINT DEFAULT 1
)
---- create above / drop below ----
DROP TABLE IF EXISTS habits;
