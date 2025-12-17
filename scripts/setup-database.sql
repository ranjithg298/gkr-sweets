-- Database Setup and RLS Policy Updates for Production Seeding
-- Run this in Supabase SQL Editor before seeding

-- Temporarily allow anonymous inserts for seeding
-- This policy allows the serverless function to insert products

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;

-- Create new policy that allows inserts with the anon key
CREATE POLICY "Allow anon inserts for seeding" ON products
  FOR INSERT WITH CHECK (true);

-- Verify the policy is active
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'products';

-- After seeding is complete, you can optionally restore the restrictive policy:
-- DROP POLICY IF EXISTS "Allow anon inserts for seeding" ON products;
-- CREATE POLICY "Authenticated users can insert products" ON products
--   FOR INSERT WITH CHECK (auth.role() = 'authenticated');
