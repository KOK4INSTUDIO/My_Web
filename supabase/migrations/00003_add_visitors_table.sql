-- Create visitors table for tracking page views
CREATE TABLE IF NOT EXISTS visitors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  page TEXT NOT NULL,
  ip_address TEXT,
  user_agent TEXT,
  visit_date TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE visitors ENABLE ROW LEVEL SECURITY;

-- Allow public insert (for tracking)
CREATE POLICY "Allow public insert on visitors" ON visitors
  FOR INSERT WITH CHECK (true);

-- Allow authenticated read
CREATE POLICY "Allow authenticated read on visitors" ON visitors
  FOR SELECT USING (auth.role() = 'authenticated');

-- Create index for faster queries by date
CREATE INDEX IF NOT EXISTS idx_visitors_visit_date ON visitors(visit_date);
