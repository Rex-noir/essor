CREATE INDEX idx_habits_user_id ON habits(user_id);
CREATE INDEX idx_habits_active ON habits(user_id, is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_habit_categories_user_id ON habit_categories(user_id);
CREATE INDEX idx_habit_entries_habit_date ON habit_entries(habit_id, entry_date);
CREATE INDEX idx_habit_entries_user_date ON habit_entries(user_id, entry_date);
CREATE INDEX idx_habit_entries_sync ON habit_entries(user_id, sync_version) WHERE deleted_at IS NULL;

CREATE INDEX idx_habits_sync_version ON habits(user_id, sync_version) WHERE deleted_at IS NULL;
CREATE INDEX idx_categories_sync_version ON habit_categories(user_id, sync_version) WHERE deleted_at IS NULL;
CREATE INDEX idx_entries_sync_version ON habit_entries(user_id, sync_version) WHERE deleted_at IS NULL;

---- create above / drop below ----

DROP INDEX IF EXISTS idx_entries_sync_version;
DROP INDEX IF EXISTS idx_categories_sync_version;
DROP INDEX IF EXISTS idx_habits_sync_version;

DROP INDEX IF EXISTS idx_habit_entries_sync;
DROP INDEX IF EXISTS idx_habit_entries_user_date;
DROP INDEX IF EXISTS idx_habit_entries_habit_date;
DROP INDEX IF EXISTS idx_habit_categories_user_id;
DROP INDEX IF EXISTS idx_habits_active;
DROP INDEX IF EXISTS idx_habits_user_id;
