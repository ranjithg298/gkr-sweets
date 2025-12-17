# 🚀 Quick Deployment Guide

## ⚡ Fast Track to Production

### 1️⃣ Update Supabase (2 minutes)

```sql
-- Go to: https://supabase.com/dashboard
-- Project: mamsjkoxduulgveshdcf
-- SQL Editor → Run this:

DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;
CREATE POLICY "Allow anon inserts for seeding" ON products FOR INSERT WITH CHECK (true);
```

### 2️⃣ Deploy to Vercel (5 minutes)

1. Go to [vercel.com](https://vercel.com)
2. Click **"Add New"** → **"Project"**
3. Import: `ranjithg298/gkr-sweets`
4. Click **"Deploy"** (use default settings)

### 3️⃣ Seed Products (30 seconds)

After deployment, run:

```powershell
Invoke-WebRequest -Uri "https://YOUR-URL.vercel.app/api/seed-products" -Method POST
```

Replace `YOUR-URL` with your Vercel deployment URL.

### 4️⃣ Verify (1 minute)

- Visit: `https://YOUR-URL.vercel.app`
- Check products display
- Test cart functionality

---

## 📊 What You're Deploying

- ✅ **121 validated products** (removed 6 invalid entries)
- ✅ **Automated seeding** via serverless function
- ✅ **Batch processing** (50 products/batch)
- ✅ **Retry logic** (3 attempts with backoff)
- ✅ **Full e-commerce site** (cart, checkout, admin)

---

## 🔗 Important Links

- **GitHub Repo**: https://github.com/ranjithg298/gkr-sweets
- **Supabase Dashboard**: https://supabase.com/dashboard
- **Vercel Dashboard**: https://vercel.com/dashboard

---

## 📚 Full Documentation

See [`VERCEL_DEPLOYMENT.md`](file:///c:/My%20Web%20Sites/gkr%20sweet/VERCEL_DEPLOYMENT.md) for complete details.

---

## ⚠️ Note

The original `products.json` had **127 products**, but **6 were invalid** "404 Not Found" placeholders. The cleaned dataset has **121 valid products** ready for production.
