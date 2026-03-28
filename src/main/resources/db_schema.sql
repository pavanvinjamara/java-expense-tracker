//run below query for all tables in db:
show create table table_name;

-- 1. USERS (identity only)
CREATE TABLE users(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- use integer only

    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL, //rename to password only
    -- phone VARCHAR(20), //remove column

    is_active BOOLEAN DEFAULT TRUE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    -- is_phone_verified BOOLEAN DEFAULT FALSE, remove column

    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP,

    -- last_login_at TIMESTAMP, remove column
    -- failed_login_attempts INT DEFAULT 0, remove column
    -- locked_until TIMESTAMP, remove column

    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);


-- add all columns of USER PROFILE into USER table, no need of extra USER PROFILE table
--  . USER PROFILE
CREATE TABLE user_profiles(
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url TEXT,
    dob DATE,
    gender VARCHAR(10)
)

-- . ADDRESSES
CREATE TABLE addresses(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),-- use integer only
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,-- use integer only, remove REFERENCES & CASCADE

    line1 TEXT,
    line2 TEXT,
    city VARCHAR(20),
    state VARCHAR(20),
    pincode VARCHAR(20),

    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now()
    -- add updated_at
)

--  . CATEGORIES
CREATE TABLE categories(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- use integer only
    name VARCHAR(20),
    parent_id UUID REFERENCES categories(id), -- remove REFERENCES
    -- add created_at, updated_at
)

-- . PRODUCTS
CREATE TABLE products(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),-- use integer only

    name VARCHAR(255),
    description TEXT,
    category_id UUID REFERENCES categories(id),-- use integer only, remove REFERENCES
    created_by UUID REFERENCES users(id), -- use integer only, remove REFERENCES

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT now()
        -- add updated_at
)

-- lets not use PRODUCT VARIANTS concept at all, add columns price, stock, updated_at, sku in PRODUCT table
-- . PRODUCT VARIANTS
CREATE TABLE product_variants(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID REFERENCES  products(id) ON DELETE CASCADE,
    price NUMERIC(10, 2),
    stock INT,

    sku VARCHAR(100) UNIQUE, -- sku means Stock Keeping Unit

    attributes JSONB, -- size, color etc.

    created_at TIMESTAMP DEFAULT now()
)

-- . PRODUCT IMAGES
CREATE TABLE product_images(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),-- use integer only
    product_id UUID REFERENCES products(id) ON DELETE CASCADE ,-- remove CASCADE

    image_url TEXT, -- lets store images in object storage(MinIO instead of AWS S3), read: https://chatgpt.com/s/t_69c7f422f78c81919e81731a368e1211
    is_primary BOOLEAN DEFAULT FALSE
)

-- . CART
CREATE TABLE cart_items(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) on DELETE  CASCADE,-- use integer only, remove CASCADE
    variant_id UUID REFERENCES product_variants(id),-- remove column & add product_id column

    quantity INT,
    created_at TIMESTAMP DEFAULT now()
    -- add updated_at
)

-- . ORDERS
CREATE TABLE orders(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- use integer only

    user_id UUID REFERENCES users(id),--remove REFERENCES
    address_id UUID REFERENCES addresses(id),--remove REFERENCES

    status VARCHAR(20), -- pending, shipped, delivered
    payment_status VARCHAR(50),
    total_amount NUMERIC(10, 2),
    created_at TIMESTAMP DEFAULT now()
    -- add updated_at
)

-- . ORDER ITEMS
CREATE TABLE order_items(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),-- use integer only

    order_id UUID REFERENCES  orders(id) ON DELETE CASCADE, --remove REFERENCES
    variant_id UUID REFERENCES product_variants(id),--remove REFERENCES

    quantity INT,
    price_at_purchase NUMERIC(10, 2) --rename col to price
    -- add created_at, updated_at
)

-- . PAYMENTS
CREATE TABLE payments(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- use integer only

    order_id UUID REFERENCES  orders(id), -- use integer only, remove REFERENCES
    method VARCHAR(50), -- UPI, card, COD
    status VARCHAR(50),

    transaction_id VARCHAR(255),

    created_at TIMESTAMP DEFAULT now()
)

-- . REVIEWS
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),-- use integer only
    user_id REFERENCES users(id),--remove REFERENCES
    product_id REFERENCES products(id),--remove REFERENCES

    rating INT CHECK (rating >= 1 AND rating <= 5),-- use integer only, check should be in code only
    comment VARCHAR(255),

    created_at TIMESTAMP DEFAULT now()
        -- add updated_at

)
