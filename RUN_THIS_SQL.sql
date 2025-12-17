-- STEP 1: Run this SQL in Supabase SQL Editor
-- Copy and paste the following into the SQL editor and click "Run"

DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;

CREATE POLICY "Allow anon inserts for seeding" ON products
  FOR INSERT WITH CHECK (true);

-- This will return the current policies to verify it worked
SELECT 
  policyname,
  cmd,
  with_check
FROM pg_policies
WHERE tablename = 'products';
