INSERT INTO users (username, email, password_hash)
VALUES
    ('john', 'john@example.com', 'demo_hash1'),
    ('anna', 'anna@example.com', 'demo_hash2');


INSERT INTO accounts (user_id, name, balance, currency)
VALUES
    (1, 'Main Account', 2500.00, 'PLN'),
    (1, 'Savings Account', 10000.00, 'PLN'),
    (2, 'Main Account', 1800.00, 'PLN');


INSERT INTO account_permissions (account_id, user_id, permission)
VALUES
    (1, 2, 'view');


INSERT INTO categories (user_id, name, type)
VALUES
    (1, 'Salary', 'income'),
    (1, 'Food', 'expense'),
    (1, 'Transport', 'expense'),
    (1, 'Entertainment', 'expense'),
    (2, 'Salary', 'income'),
    (2, 'Food', 'expense');