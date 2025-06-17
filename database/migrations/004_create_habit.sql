CREATE TABLE IF NOT EXISTS habit_templates(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title varchar(100) NOT NULL,
    description text,
    habit_type varchar(20) NOT NULL CHECK (habit_type IN ('binary', 'quantitative')),
    unit varchar(20),
    target_value DECIMAL(10, 2),
    target_operator varchar(10) CHECK (target_operator IN ('>=', '<=', '=')),
    frequency varchar(20) DEFAULT 'daily' CHECK (frequency IN ('daily', 'weekly', 'monthly')),
    start_date timestamp with time zone NOT NULL weekly_days integer[] DEFAULT '{}',
    monthly_dates integer[] DEFAULT '{}',
    interval integer NOT NULL DEFAULT 1 CHECK (interval >= 1) is_shared boolean DEFAULT FALSE,
    is_active boolean DEFAULT TRUE,
    created_at timestamp with time zone DEFAULT NOW(),
    updated_at timestamp with time zone DEFAULT NOW(),
    deleted_at timestamp with time zone NULL,
    sync_version bigint DEFAULT 1)
---- create above / drop below ----
DROP TABLE IF EXISTS habits;

