CREATE TABLE payment_checkouts (
    checkout_id CHAR(36) PRIMARY KEY,
    buyer_id VARCHAR(64) NOT NULL,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE = InnoDB;

CREATE TABLE payment_orders (
    payment_order_id CHAR(36) PRIMARY KEY,
    checkout_id CHAR(36) NOT NULL,
    seller_account_id VARCHAR(64) NOT NULL,
    amount_minor BIGINT NOT NULL,
    currency CHAR(3) NOT NULL,
    status VARCHAR(32) NOT NULL,
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT fk_payment_order_checkout
        FOREIGN KEY (checkout_id)
        REFERENCES payment_checkouts(checkout_id),

    CONSTRAINT chk_payment_order_amount
        CHECK (amount_minor > 0),

    CONSTRAINT chk_payment_order_currency
        CHECK (currency = 'EUR'),

    INDEX idx_payment_orders_checkout (checkout_id)
) ENGINE = InnoDB;
