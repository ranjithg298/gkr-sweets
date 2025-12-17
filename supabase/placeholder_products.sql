-- Create placeholder_products table
CREATE TABLE IF NOT EXISTS placeholder_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    category TEXT,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url TEXT,
    slug TEXT UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample data
INSERT INTO placeholder_products (name, category, description, price, image_url, slug) VALUES
('Classic Mysore Pak', 'Sweets', 'Rich and melting Mysore Pak made with pure ghee.', 450.00, 'https://placehold.co/400x300?text=Mysore+Pak', 'classic-mysore-pak'),
('Spicy Murukku', 'Savouries', 'Crunchy rice flour snack with a spicy kick.', 120.00, 'https://placehold.co/400x300?text=Murukku', 'spicy-murukku'),
('Mixed Sweets Combo', 'Combos', 'A delightful assortment of our best sweets.', 999.00, 'https://placehold.co/400x300?text=Sweets+Combo', 'mixed-sweets-combo'),
('Banana Chips', 'Savouries', 'Crispy fried banana chips salted to perfection.', 150.00, 'https://placehold.co/400x300?text=Banana+Chips', 'banana-chips'),
('Ghee Laddu', 'Sweets', 'Traditional laddu made with roasted gram flour and ghee.', 350.00, 'https://placehold.co/400x300?text=Laddu', 'ghee-laddu');
