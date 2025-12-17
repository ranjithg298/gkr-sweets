# Database Setup Guide

## Step 1: Access Supabase SQL Editor

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: **project-f9153bb7-8dba-450a-831**
3. Click on **SQL Editor** in the left sidebar

## Step 2: Run the Schema Script

1. Click **New Query**
2. Copy the entire contents of `supabase_schema.sql`
3. Paste into the SQL editor
4. Click **Run** or press `Ctrl+Enter`

This will create:
- ✅ 6 tables (products, categories, cart_items, orders, site_settings, banners)
- ✅ Row Level Security (RLS) policies
- ✅ Indexes for performance
- ✅ Default categories (Sweets, Snacks, Mixture, etc.)
- ✅ Default site settings
- ✅ Triggers for auto-updating timestamps
- ✅ Helper functions

## Step 3: Create Storage Buckets

### Create Products Bucket
1. Go to **Storage** in the left sidebar
2. Click **New bucket**
3. Name: `products`
4. Make it **Public**
5. Click **Create bucket**

### Create Site Assets Bucket
1. Click **New bucket** again
2. Name: `site-assets`
3. Make it **Public**
4. Click **Create bucket**

### Set Storage Policies

Go to **Storage** → **Policies** and add these policies:

**For `products` bucket:**
```sql
-- Allow public to view
CREATE POLICY "Public Access" ON storage.objects 
FOR SELECT USING (bucket_id = 'products');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated Upload" ON storage.objects 
FOR INSERT WITH CHECK (bucket_id = 'products' AND auth.role() = 'authenticated');

-- Allow authenticated users to delete
CREATE POLICY "Authenticated Delete" ON storage.objects 
FOR DELETE USING (bucket_id = 'products' AND auth.role() = 'authenticated');
```

**For `site-assets` bucket:**
```sql
-- Allow public to view
CREATE POLICY "Public Access" ON storage.objects 
FOR SELECT USING (bucket_id = 'site-assets');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated Upload" ON storage.objects 
FOR INSERT WITH CHECK (bucket_id = 'site-assets' AND auth.role() = 'authenticated');

-- Allow authenticated users to delete
CREATE POLICY "Authenticated Delete" ON storage.objects 
FOR DELETE USING (bucket_id = 'site-assets' AND auth.role() = 'authenticated');
```

## Step 4: Enable Email Authentication

1. Go to **Authentication** → **Providers**
2. Make sure **Email** is enabled
3. Configure email templates if needed

## Step 5: Configure Google OAuth (Optional)

1. Go to **Authentication** → **Providers**
2. Enable **Google**
3. Add your Google OAuth credentials:
   - Client ID
   - Client Secret
4. Add redirect URL: `https://project-f9153bb7-8dba-450a-831.supabase.co/auth/v1/callback`

## Step 6: Verify Setup

Run this query to verify everything is set up:

```sql
-- Check tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check categories
SELECT * FROM categories ORDER BY display_order;

-- Check site settings
SELECT key, category FROM site_settings ORDER BY category, key;
```

You should see:
- 6 tables listed
- 7 categories
- 13 site settings

## Step 7: Get Your Anon Key

1. Go to **Settings** → **API**
2. Copy the **anon/public** key
3. Update `supabase-config.js` with the correct anon key

## Troubleshooting

**If you get permission errors:**
- Make sure RLS is enabled on all tables
- Check that policies are created correctly

**If storage doesn't work:**
- Verify buckets are set to Public
- Check storage policies are applied

**If authentication fails:**
- Verify email provider is enabled
- Check site URL is configured correctly

## Next Steps

Once database setup is complete:
1. ✅ Test authentication (register/login)
2. ✅ Upload GKR logo to site-assets bucket
3. ✅ Add sample products via admin panel
4. ✅ Test cart functionality
5. ✅ Deploy to Vercel
