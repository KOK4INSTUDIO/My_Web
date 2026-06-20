-- Enable UUID extension (in case not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create banners table
CREATE TABLE IF NOT EXISTS banners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT,
  description TEXT,
  image_url TEXT NOT NULL,
  link_url TEXT,
  schedule_start TIMESTAMPTZ,
  schedule_end TIMESTAMPTZ,
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create trigger for updated_at (drop first if exists)
DROP TRIGGER IF EXISTS update_banners_updated_at ON banners;
CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON banners
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (drop first if exists)
DROP POLICY IF EXISTS "Allow public read access on banners" ON banners;
CREATE POLICY "Allow public read access on banners" ON banners
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to manage banners" ON banners;
CREATE POLICY "Allow authenticated users to manage banners" ON banners
  USING (auth.role() = 'authenticated');
