CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    NEW.sync_version = OLD.sync_version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_habits_modtime
    BEFORE UPDATE ON habits
    FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_entries_modtime 
    BEFORE UPDATE ON habit_entries 
    FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE OR REPLACE FUNCTION is_habit_goal_met(
    p_habit_type VARCHAR(20),
    p_target_value DECIMAL(10,2),
    p_target_operator VARCHAR(10),
    p_actual_value DECIMAL(10,2),
    p_completed BOOLEAN
) RETURNS BOOLEAN AS $$
BEGIN
    IF p_habit_type = 'boolean' THEN
        RETURN COALESCE(p_completed, false);
    END IF;

    IF p_actual_value IS NULL THEN
        RETURN FALSE;
    END IF;

    CASE p_target_operator
        WHEN '>=' THEN RETURN p_actual_value >= p_target_value;
        WHEN '<=' THEN RETURN p_actual_value <= p_target_value;
        WHEN '=' THEN RETURN p_actual_value = p_target_value;
        ELSE RETURN FALSE;
    END CASE;
END;
$$ LANGUAGE plpgsql;

---- create above / drop below ----

DROP TRIGGER IF EXISTS update_habits_modtime ON habits;
DROP TRIGGER IF EXISTS update_entries_modtime ON habit_entries;

DROP FUNCTION IF EXISTS update_modified_column();
DROP FUNCTION IF EXISTS is_habit_goal_met();
