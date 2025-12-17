# 🚀 DEPLOYMENT STEPS - DO THIS NOW

## ✅ STEP 1: Update Supabase Database (30 seconds)

**You have the Supabase SQL Editor open in your browser**

1. **Copy this SQL** (from `RUN_THIS_SQL.sql`):
```sql
DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;

CREATE POLICY "Allow anon inserts for seeding" ON products
  FOR INSERT WITH CHECK (true);

SELECT policyname, cmd, with_check
FROM pg_policies
WHERE tablename = 'products';
```

2. **Paste into the SQL editor**
3. **Click "Run"** button
4. **Verify** you see the policy "Allow anon inserts for seeding" in the results

---

## ✅ STEP 2: Deploy to Vercel (2 minutes)

**You have Vercel import page open in your browser**

1. **Find** the `gkr-sweets` repository (should be visible)
2. **Click "Import"** next to `ranjithg298/gkr-sweets`
3. **Leave all settings as default**
4. **Click "Deploy"**
5. **Wait** for deployment to complete (~2 minutes)
6. **Copy the deployment URL** (will be something like `https://gkr-sweets-xxx.vercel.app`)

---

## ✅ STEP 3: Seed Products (30 seconds)

**After deployment completes:**

1. **Open PowerShell** (or use the one below)
2. **Run this command** (replace YOUR-URL with your Vercel URL):

```powershell
Invoke-WebRequest -Uri "https://YOUR-VERCEL-URL.vercel.app/api/seed-products" -Method POST
```

**Example:**
```powershell
Invoke-WebRequest -Uri "https://gkr-sweets-abc123.vercel.app/api/seed-products" -Method POST
```

3. **Wait** for response (should take 5-10 seconds)
4. **Verify** you see: `"successful": 121`

---

## ✅ STEP 4: Test Your Site

Visit your Vercel URL: `https://YOUR-VERCEL-URL.vercel.app`

You should see:
- ✅ Homepage with products
- ✅ Product images loading
- ✅ Cart functionality working

---

## 🎉 DONE!

Your GKR Sweets e-commerce site is now LIVE with all 121 products!

**Tell me when you complete each step and I'll help if you encounter any issues!**
