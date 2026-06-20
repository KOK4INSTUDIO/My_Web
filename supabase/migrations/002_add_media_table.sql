-- Enable UUID extension (in case not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create media table
CREATE TABLE IF NOT EXISTS media (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'image',
  size INTEGER,
  storage_path TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create trigger for updated_at (drop first if exists)
DROP TRIGGER IF EXISTS update_media_updated_at ON media;
CREATE TRIGGER update_media_updated_at BEFORE UPDATE ON media
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE media ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (drop first if exists)
DROP POLICY IF EXISTS "Allow public read access on media" ON media;
CREATE POLICY "Allow public read access on media" ON media
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to manage media" ON media;
CREATE POLICY "Allow authenticated users to manage media" ON media
  USING (auth.role() = 'authenticated');
