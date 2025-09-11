CREATE TYPE display_type AS ENUM ('all_currencies', 'reference_currency');

CREATE TABLE IF NOT EXISTS settings
(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),

    reference_currency_id INTEGER NOT NULL REFERENCES currencies (id) ON DELETE RESTRICT,
    display_type display_type NOT NULL DEFAULT 'all_currencies',
    
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_settings_updated_at
BEFORE UPDATE ON settings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();









