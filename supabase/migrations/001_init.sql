-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create tables
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT,
    parent_id UUID REFERENCES categories(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES categories(id),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    sku VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    specifications JSONB DEFAULT '{}'::jsonb,
    gallery JSONB DEFAULT '[]'::jsonb,
    price DECIMAL(10, 2) NOT NULL,
    promo_price DECIMAL(10, 2),
    stock INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'best_seller', 'coming_soon', 'out_of_stock')),
    is_featured BOOLEAN DEFAULT FALSE,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS inventory_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products(id) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('in', 'out', 'adjustment')),
    quantity INTEGER NOT NULL,
    stock_before INTEGER NOT NULL,
    stock_after INTEGER NOT NULL,
    note TEXT,
    admin_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pre_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama_pemesan VARCHAR(255) NOT NULL,
    produk VARCHAR(255) NOT NULL,
    jumlah INTEGER NOT NULL,
    platform VARCHAR(50) NOT NULL CHECK (platform IN ('whatsapp', 'shopee', 'tokopedia')),
    status VARCHAR(50) NOT NULL DEFAULT 'baru' CHECK (status IN ('baru', 'dikonfirmasi', 'diproses', 'dikirim', 'selesai', 'dibatalkan')),
    status_history JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS visitor_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255),
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('page_view', 'product_view', 'whatsapp_click', 'shopee_click', 'tokopedia_click')),
    page_path VARCHAR(255),
    product_id UUID REFERENCES products(id),
    source VARCHAR(255),
    device_type VARCHAR(100),
    browser VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS banners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255),
    description TEXT,
    image_url TEXT NOT NULL,
    link_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(255) NOT NULL UNIQUE,
    value JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    action VARCHAR(255) NOT NULL,
    table_name VARCHAR(255),
    record_id UUID,
    old_data JSONB,
    new_data JSONB,
    admin_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_inventory_logs_product ON inventory_logs(product_id);
CREATE INDEX IF NOT EXISTS idx_pre_orders_status ON pre_orders(status);
CREATE INDEX IF NOT EXISTS idx_visitor_events_event ON visitor_events(event_type);
CREATE INDEX IF NOT EXISTS idx_visitor_events_product ON visitor_events(product_id);
CREATE INDEX IF NOT EXISTS idx_visitor_events_created ON visitor_events(created_at);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE pre_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitor_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Categories
CREATE POLICY "Enable read access for all users" ON categories FOR SELECT USING (true);
CREATE POLICY "Enable all access for authenticated users" ON categories FOR ALL USING (auth.role() = 'authenticated');

-- Products
CREATE POLICY "Enable read access for all users" ON products FOR SELECT USING (true);
CREATE POLICY "Enable all access for authenticated users" ON products FOR ALL USING (auth.role() = 'authenticated');

-- Inventory Logs
CREATE POLICY "Enable read access for authenticated users" ON inventory_logs FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Enable insert for authenticated users" ON inventory_logs FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Pre-Orders
CREATE POLICY "Enable read access for authenticated users" ON pre_orders FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Enable insert for all users" ON pre_orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users" ON pre_orders FOR UPDATE USING (auth.role() = 'authenticated');

-- Visitor Events
CREATE POLICY "Enable insert for all users" ON visitor_events FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable read access for authenticated users" ON visitor_events FOR SELECT USING (auth.role() = 'authenticated');

-- Banners
CREATE POLICY "Enable read access for all users" ON banners FOR SELECT USING (true);
CREATE POLICY "Enable all access for authenticated users" ON banners FOR ALL USING (auth.role() = 'authenticated');

-- Settings
CREATE POLICY "Enable read access for all users" ON settings FOR SELECT USING (true);
CREATE POLICY "Enable all access for authenticated users" ON settings FOR ALL USING (auth.role() = 'authenticated');

-- Audit Logs
CREATE POLICY "Enable read access for authenticated users" ON audit_logs FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Enable insert for authenticated users" ON audit_logs FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Create function to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pre_orders_updated_at BEFORE UPDATE ON pre_orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON banners
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_settings_updated_at BEFORE UPDATE ON settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();