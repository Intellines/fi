-- auto updated_at function
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--
DROP TABLE IF EXISTS version;
--

-- Schema versions
CREATE TABLE schema_versions
(
    version VARCHAR(50) PRIMARY KEY,
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Currencies
CREATE TABLE currencies
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL CHECK (LENGTH(name) > 0),
    code CHAR(3) NOT NULL UNIQUE,
    numeric_code SMALLINT NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Users
CREATE TABLE users
(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) NOT NULL UNIQUE CHECK (LENGTH(username) > 0),
    email VARCHAR(255) NOT NULL UNIQUE CHECK (LENGTH(email) > 0),
    base_currency_id INTEGER NOT NULL REFERENCES currencies (id) ON DELETE RESTRICT,
    external_user_id uuid UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Accounts
CREATE TABLE accounts
(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL CHECK (LENGTH(name) > 0),
    description TEXT,
    user_id uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Asset types
CREATE TYPE asset_type AS ENUM ('bank', 'cash', 'investment');

-- Assets
CREATE TABLE assets
(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL CHECK (LENGTH(name) > 0),
    description TEXT,
    account_id uuid NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    asset_type asset_type NOT NULL,
    initial_balance NUMERIC(20, 4) NOT NULL DEFAULT 0 CHECK (initial_balance >= 0),
    current_balance NUMERIC(20, 4) NOT NULL DEFAULT 0 CHECK (current_balance >= 0),
    currency_id INTEGER NOT NULL REFERENCES currencies (id) ON DELETE RESTRICT,
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Categories
CREATE TABLE categories
(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL CHECK (LENGTH(name) > 0),
    icon VARCHAR(50) NOT NULL,
    description TEXT,
    account_id uuid NOT NULL REFERENCES accounts (id) ON DELETE CASCADE,
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT unique_category_name_per_account UNIQUE (account_id, name)
);

-- Transaction types
CREATE TYPE transaction_type AS ENUM ('income', 'expense', 'transfer');

-- Transactions
CREATE TABLE transactions
(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_id uuid NOT NULL REFERENCES assets (id) ON DELETE RESTRICT,
    category_id uuid NOT NULL REFERENCES categories (id) ON DELETE RESTRICT,
    description TEXT,
    amount NUMERIC(20, 4) NOT NULL CHECK (amount != 0),
    transaction_type transaction_type NOT NULL,
    transaction_date TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX idx_users_base_currency_id ON users (base_currency_id);
CREATE INDEX idx_accounts_user_id ON accounts (user_id);
CREATE INDEX idx_assets_account_id ON assets (account_id);
CREATE INDEX idx_assets_currency_id ON assets (currency_id);
CREATE INDEX idx_categories_account_id ON categories (account_id);
CREATE INDEX idx_transactions_asset_id ON transactions (asset_id);
CREATE INDEX idx_transactions_category_id ON transactions (category_id);
CREATE INDEX idx_transactions_transaction_date ON transactions (transaction_date);

-- Triggers
CREATE TRIGGER trg_schema_versions_updated_at
BEFORE UPDATE ON schema_versions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_currencies_updated_at
BEFORE UPDATE ON currencies
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_accounts_updated_at
BEFORE UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_assets_updated_at
BEFORE UPDATE ON assets
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_transactions_updated_at
BEFORE UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();