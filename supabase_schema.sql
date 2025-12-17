-- GKR Sweets Database Schema
-- Supabase SQL Setup Script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- PRODUCTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  compare_price DECIMAL(10, 2),
  category TEXT NOT NULL,
  images TEXT[] NOT NULL DEFAULT '{}',
  stock INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT false,
  active BOOLEAN DEFAULT true,
  weight TEXT,
  sku TEXT UNIQUE,
  tags TEXT[],
  created_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Policies for products
CREATE POLICY "Anyone can view active products" ON products
  FOR SELECT USING (active = true);

CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update products" ON products
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete products" ON products
  FOR DELETE USING (auth.role() = 'authenticated');

-- Index for better performance
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_featured ON products(featured);
CREATE INDEX idx_products_slug ON products(slug);

-- =====================================================
-- CATEGORIES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  image TEXT,
  display_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Policies for categories
CREATE POLICY "Anyone can view active categories" ON categories
  FOR SELECT USING (active = true);

CREATE POLICY "Authenticated users can manage categories" ON categories
  FOR ALL USING (auth.role() = 'authenticated');

-- Index
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_order ON categories(display_order);

-- =====================================================
-- CART ITEMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS cart_items (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  session_id TEXT,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(session_id, product_id),
  UNIQUE(user_id, product_id)
);

-- Enable RLS
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Policies for cart_items
CREATE POLICY "Users can view their own cart" ON cart_items
  FOR SELECT USING (
    auth.uid() = user_id OR 
    session_id = current_setting('app.session_id', true)
  );

CREATE POLICY "Users can insert to their cart" ON cart_items
  FOR INSERT WITH CHECK (
    auth.uid() = user_id OR 
    session_id = current_setting('app.session_id', true)
  );

CREATE POLICY "Users can update their cart" ON cart_items
  FOR UPDATE USING (
    auth.uid() = user_id OR 
    session_id = current_setting('app.session_id', true)
  );

CREATE POLICY "Users can delete from their cart" ON cart_items
  FOR DELETE USING (
    auth.uid() = user_id OR 
    session_id = current_setting('app.session_id', true)
  );

-- Index
CREATE INDEX idx_cart_user ON cart_items(user_id);
CREATE INDEX idx_cart_session ON cart_items(session_id);

-- =====================================================
-- ORDERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  order_number TEXT UNIQUE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  email TEXT NOT NULL,
  phone TEXT,
  items JSONB NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,
  shipping_cost DECIMAL(10, 2) DEFAULT 0,
  tax DECIMAL(10, 2) DEFAULT 0,
  total DECIMAL(10, 2) NOT NULL,
  status TEXT DEFAULT 'pending',
  payment_status TEXT DEFAULT 'pending',
  payment_method TEXT,
  payment_id TEXT,
  shipping_address JSONB NOT NULL,
  billing_address JSONB,
  notes TEXT,
  gokwik_order_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Policies for orders
CREATE POLICY "Users can view their own orders" ON orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Authenticated admins can view all orders" ON orders
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Anyone can insert orders" ON orders
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can update orders" ON orders
  FOR UPDATE USING (auth.role() = 'authenticated');

-- Index
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created ON orders(created_at DESC);

-- =====================================================
-- SITE SETTINGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS site_settings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Policies for site_settings
CREATE POLICY "Anyone can view site settings" ON site_settings
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage settings" ON site_settings
  FOR ALL USING (auth.role() = 'authenticated');

-- Index
CREATE INDEX idx_settings_key ON site_settings(key);
CREATE INDEX idx_settings_category ON site_settings(category);

-- =====================================================
-- BANNERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS banners (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  image TEXT NOT NULL,
  mobile_image TEXT,
  link TEXT,
  button_text TEXT,
  display_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;

-- Policies for banners
CREATE POLICY "Anyone can view active banners" ON banners
  FOR SELECT USING (
    active = true AND 
    (start_date IS NULL OR start_date <= NOW()) AND 
    (end_date IS NULL OR end_date >= NOW())
  );

CREATE POLICY "Authenticated users can manage banners" ON banners
  FOR ALL USING (auth.role() = 'authenticated');

-- Index
CREATE INDEX idx_banners_order ON banners(display_order);
CREATE INDEX idx_banners_active ON banners(active);

-- =====================================================
-- INSERT DEFAULT DATA
-- =====================================================

-- Default categories
INSERT INTO categories (name, slug, description, display_order) VALUES
  ('Sweets', 'sweets', 'Traditional Indian Sweets', 1),
  ('Snacks', 'snacks', 'Crispy and Tasty Snacks', 2),
  ('Mixture', 'mixture', 'Delicious Mixture Varieties', 3),
  ('Muruku', 'muruku', 'Traditional Muruku', 4),
  ('Halwa', 'halwa', 'Sweet Halwa Varieties', 5),
  ('Laddu', 'laddu', 'Traditional Laddu', 6),
  ('Bakery', 'bakery', 'Fresh Bakery Items', 7)
ON CONFLICT (slug) DO NOTHING;

-- Default site settings
INSERT INTO site_settings (key, value, category, description) VALUES
  ('site_name', '"GKR Sweets"', 'general', 'Site name'),
  ('site_tagline', '"Traditional Indian Sweets & Snacks"', 'general', 'Site tagline'),
  ('contact_email', '"info@gkrsweets.com"', 'contact', 'Contact email'),
  ('contact_phone', '"+91 1234567890"', 'contact', 'Contact phone'),
  ('contact_address', '"123 Sweet Street, Chennai, India"', 'contact', 'Contact address'),
  ('social_facebook', '"https://facebook.com/gkrsweets"', 'social', 'Facebook URL'),
  ('social_instagram', '"https://instagram.com/gkrsweets"', 'social', 'Instagram URL'),
  ('social_twitter', '"https://twitter.com/gkrsweets"', 'social', 'Twitter URL'),
  ('social_youtube', '"https://youtube.com/gkrsweets"', 'social', 'YouTube URL'),
  ('footer_about', '"GKR Sweets is your destination for authentic traditional Indian sweets and snacks. We bring the taste of tradition to your doorstep."', 'footer', 'About text in footer'),
  ('shipping_info', '"Free shipping on orders above ₹500"', 'general', 'Shipping information'),
  ('currency', '"INR"', 'general', 'Currency code'),
  ('currency_symbol', '"₹"', 'general', 'Currency symbol')
ON CONFLICT (key) DO NOTHING;

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cart_items_updated_at BEFORE UPDATE ON cart_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON banners
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
  new_number TEXT;
BEGIN
  SELECT 'GKR' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(NEXTVAL('order_number_seq')::TEXT, 4, '0')
  INTO new_number;
  RETURN new_number;
END;
$$ LANGUAGE plpgsql;

-- Create sequence for order numbers
CREATE SEQUENCE IF NOT EXISTS order_number_seq START 1;

-- =====================================================
-- STORAGE BUCKETS (Run these in Supabase Dashboard)
-- =====================================================

-- Create storage buckets via Supabase Dashboard:
-- 1. Go to Storage in Supabase Dashboard
-- 2. Create bucket: "products" (Public)
-- 3. Create bucket: "site-assets" (Public)

-- Storage policies (run after creating buckets):
-- For products bucket:
-- CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (bucket_id = 'products');
-- CREATE POLICY "Authenticated Upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'products' AND auth.role() = 'authenticated');
-- CREATE POLICY "Authenticated Delete" ON storage.objects FOR DELETE USING (bucket_id = 'products' AND auth.role() = 'authenticated');

-- For site-assets bucket:
-- CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (bucket_id = 'site-assets');
-- CREATE POLICY "Authenticated Upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'site-assets' AND auth.role() = 'authenticated');
-- CREATE POLICY "Authenticated Delete" ON storage.objects FOR DELETE USING (bucket_id = 'site-assets' AND auth.role() = 'authenticated');
