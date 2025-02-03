CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$ 
DECLARE 
    rec RECORD;
BEGIN
    FOR rec IN 
        (SELECT table_name 
         FROM information_schema.columns 
         WHERE column_name = 'updated_at' 
           AND table_schema = 'public') 
    LOOP
        EXECUTE format('
            CREATE TRIGGER update_timestamp_%I
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();',
            rec.table_name, rec.table_name);
    END LOOP;
END $$;
