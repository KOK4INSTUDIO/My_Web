-- Add view_count column to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0;

-- Create index for view_count for faster sorting
CREATE INDEX IF NOT EXISTS idx_products_view_count ON products(view_count DESC);
