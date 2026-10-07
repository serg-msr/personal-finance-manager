CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE accounts (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,

    balance NUMERIC(12, 2) NOT NULL DEFAULT 0,

    currency CHAR(3) NOT NULL DEFAULT 'PLN',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE account_permissions (
    id BIGSERIAL PRIMARY KEY,

    account_id BIGINT NOT NULL
        REFERENCES accounts(id)
        ON DELETE CASCADE,

    user_id BIGINT NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    permission VARCHAR(20) NOT NULL
        CHECK (permission IN ('view', 'transact')),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (account_id, user_id)
);


CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,

    type VARCHAR(20) NOT NULL
        CHECK (type IN ('income', 'expense')),

    UNIQUE (user_id, name, type)
);


CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,

    source_account_id BIGINT
        REFERENCES accounts(id)
        ON DELETE RESTRICT,

    destination_account_id BIGINT
        REFERENCES accounts(id)
        ON DELETE RESTRICT,

    category_id BIGINT
        REFERENCES categories(id)
        ON DELETE RESTRICT,

    amount NUMERIC(12, 2) NOT NULL
        CHECK (amount > 0),

    type VARCHAR(20) NOT NULL
        CHECK (type IN ('income', 'expense', 'transfer')),

    status VARCHAR(20)
        CHECK (status IN (
            'pending',
            'accepted',
            'rejected',
            'cancelled'
        )),

    description TEXT,

    date DATE NOT NULL DEFAULT CURRENT_DATE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (
        source_account_id IS NOT NULL
        OR destination_account_id IS NOT NULL
    ),

    CHECK (
        source_account_id IS NULL
        OR destination_account_id IS NULL
        OR source_account_id <> destination_account_id
    ),

    CHECK (
        (type = 'income'
            AND source_account_id IS NULL
            AND destination_account_id IS NOT NULL
            AND category_id IS NOT NULL)

        OR

        (type = 'expense'
            AND source_account_id IS NOT NULL
            AND destination_account_id IS NULL
            AND category_id IS NOT NULL)

        OR

        (type = 'transfer'
            AND source_account_id IS NOT NULL
            AND destination_account_id IS NOT NULL
            AND category_id IS NULL)
    ),

    CHECK (
        type = 'transfer'
        OR status IS NULL
    )
);


CREATE INDEX idx_accounts_user_id
ON accounts(user_id);


CREATE INDEX idx_account_permissions_user_id
ON account_permissions(user_id);


CREATE INDEX idx_account_permissions_account_id
ON account_permissions(account_id);


CREATE INDEX idx_categories_user_id
ON categories(user_id);


CREATE INDEX idx_transactions_source_account_id
ON transactions(source_account_id);


CREATE INDEX idx_transactions_destination_account_id
ON transactions(destination_account_id);


CREATE INDEX idx_transactions_category_id
ON transactions(category_id);


CREATE INDEX idx_transactions_date
ON transactions(date);