# ✅ FIXED - Use This SQL File Instead

## The Problem
The original `supabase_schema.sql` had storage policy commands that require the correct anon key, causing the JWT error.

## The Solution
Use `supabase_schema_simple.sql` instead - it creates all tables WITHOUT storage policies.

## Steps to Run (2 minutes):

1. **Open the new file**: `supabase_schema_simple.sql`
2. **Copy everything** (Ctrl+A, Ctrl+C)
3. **In Supabase SQL Editor**:
   - Clear any existing SQL
   - Paste the new SQL
   - Click **Run** (or Ctrl+Enter)
4. **Wait for success message**

## What This Creates:
- ✅ 6 tables (products, categories, cart_items, orders, site_settings, banners)
- ✅ All security policies (RLS)
- ✅ Default categories (7 categories)
- ✅ Default site settings (13 settings)
- ✅ Helper functions
- ✅ Auto-update triggers

## After SQL Runs Successfully:

### Create Storage Buckets (1 minute):
1. Click **Storage** in left sidebar
2. Click **New bucket**
3. Name: `products`, Public: ✅, Click **Create**
4. Click **New bucket** again
5. Name: `site-assets`, Public: ✅, Click **Create**

That's it! No need to mess with anon keys or storage policies.

## Then Tell Me:
Just say "database done" and I'll continue with the admin panel and cart functionality!
