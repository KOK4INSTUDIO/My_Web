-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  sku TEXT UNIQUE,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  description TEXT,
  price NUMERIC(10, 2) NOT NULL DEFAULT 0,
  promo_price NUMERIC(10, 2),
  stock INTEGER NOT NULL DEFAULT 0,
  gallery TEXT[] DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'draft',
  is_featured BOOLEAN DEFAULT FALSE,
  specifications JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create site_settings table
CREATE TABLE IF NOT EXISTS site_settings (
  id TEXT PRIMARY KEY,
  title TEXT,
  content1 TEXT,
  content2 TEXT,
  content3 TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create pre_orders table
CREATE TABLE IF NOT EXISTS pre_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_name TEXT NOT NULL,
  customer_email TEXT,
  customer_phone TEXT NOT NULL,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  total_price NUMERIC(10, 2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create function to automatically update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at (drop first if exists)
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_site_settings_updated_at ON site_settings;
CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_pre_orders_updated_at ON pre_orders;
CREATE TRIGGER update_pre_orders_updated_at BEFORE UPDATE ON pre_orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS) - optional but recommended
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE pre_orders ENABLE ROW LEVEL SECURITY;

-- Create RLS policies to allow public read (for user view) (drop first if exists)
DROP POLICY IF EXISTS "Allow public read access on categories" ON categories;
CREATE POLICY "Allow public read access on categories" ON categories
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public read access on products" ON products;
CREATE POLICY "Allow public read access on products" ON products
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public read access on site_settings" ON site_settings;
CREATE POLICY "Allow public read access on site_settings" ON site_settings
  FOR SELECT USING (true);

-- Create RLS policies to allow authenticated users to manage data (drop first if exists)
DROP POLICY IF EXISTS "Allow authenticated users to manage categories" ON categories;
CREATE POLICY "Allow authenticated users to manage categories" ON categories
  USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Allow authenticated users to manage products" ON products;
CREATE POLICY "Allow authenticated users to manage products" ON products
  USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Allow authenticated users to manage site_settings" ON site_settings;
CREATE POLICY "Allow authenticated users to manage site_settings" ON site_settings
  USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Allow authenticated users to manage pre_orders" ON pre_orders;
CREATE POLICY "Allow authenticated users to manage pre_orders" ON pre_orders
  USING (auth.role() = 'authenticated');

-- Insert default about content
INSERT INTO site_settings (id, title, content1, content2, content3)
VALUES (
  'about_content',
  'Tentang KOK4INSTUDIO',
  'KOK4INSTUDIO adalah brand fashion yang lahir dari semangat untuk terus berkarya dan menghadirkan produk berkualitas bagi setiap pelanggan. Kami baru memulai perjalanan di dunia fashion, namun kami memiliki komitmen yang kuat untuk menghasilkan berbagai produk custom yang dibuat dengan perhatian terhadap detail, kualitas, dan identitas yang khas.',
  'Setiap produk yang kami hadirkan dirancang untuk memberikan kenyamanan, nilai estetika, serta karakter yang dapat mewakili gaya dan kepribadian penggunanya. Kami percaya bahwa sebuah produk tidak hanya sekadar pakaian atau aksesori, tetapi juga menjadi bagian dari identitas dan ekspresi diri.',
  'Dengan mengutamakan kualitas bahan, proses produksi yang teliti, serta pelayanan terbaik, KOK4INSTUDIO terus berupaya berkembang dan menghadirkan karya-karya yang dapat dibanggakan. Terima kasih telah menjadi bagian dari perjalanan kami dalam menciptakan produk fashion yang autentik dan bernilai.'
) ON CONFLICT (id) DO NOTHING;
