# 🚀 GKR Sweets - Vercel Deployment Guide

Complete guide for deploying GKR Sweets to Vercel with automated product seeding.

## 📋 Prerequisites

- GitHub account
- Vercel account (sign up at [vercel.com](https://vercel.com))
- Supabase project (already configured)

## 🗄️ Database Setup

### Step 1: Update RLS Policies

Before seeding, you need to update Supabase Row Level Security policies:

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `mamsjkoxduulgveshdcf`
3. Navigate to **SQL Editor**
4. Run the SQL script from `scripts/setup-database.sql`:

```sql
-- Allow anonymous inserts for seeding
DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;
CREATE POLICY "Allow anon inserts for seeding" ON products
  FOR INSERT WITH CHECK (true);
```

5. Click **Run** to execute

## 🔧 Deployment Steps

### Step 2: Push to GitHub

If not already done, push your code to GitHub:

```bash
cd "c:\My Web Sites\gkr sweet"
git init
git add .
git commit -m "Initial commit - GKR Sweets e-commerce site"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/gkr-sweets.git
git push -u origin main
```

### Step 3: Deploy to Vercel

1. **Go to Vercel**: Visit [vercel.com](https://vercel.com) and sign in
2. **Import Project**: Click "Add New" → "Project"
3. **Import Repository**: Select your `gkr-sweets` repository
4. **Configure Project**:
   - **Framework Preset**: Other
   - **Root Directory**: `./`
   - **Build Command**: (leave empty)
   - **Output Directory**: (leave empty)
   - **Install Command**: `npm install`

5. **Environment Variables**: Add the following (already in vercel.json but can override):
   ```
   SUPABASE_URL=https://mamsjkoxduulgveshdcf.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hbXNqa294ZHV1bGd2ZXNoZGNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MjY3NzEsImV4cCI6MjA3OTQwMjc3MX0.rk2qTSXHJbdR23Buesz7kEV0CCk9IJP961Ym2TyWFEo
   ```

6. **Deploy**: Click "Deploy" and wait for deployment to complete

### Step 4: Seed Products

Once deployed, seed your products using the serverless function:

**Option A: Using curl (Command Line)**
```bash
curl -X POST https://your-vercel-url.vercel.app/api/seed-products
```

**Option B: Using Browser**
1. Open your browser
2. Navigate to: `https://your-vercel-url.vercel.app/api/seed-products`
3. Use a tool like Postman or make a POST request

**Option C: Using PowerShell**
```powershell
Invoke-WebRequest -Uri "https://your-vercel-url.vercel.app/api/seed-products" -Method POST
```

### Step 5: Verify Seeding

1. **Check Response**: You should see:
   ```json
   {
     "success": true,
     "message": "Successfully seeded 121 products in X.XXs",
     "results": {
       "total": 121,
       "successful": 121,
       "failed": 0,
       "batches": [...],
       "duration": "X.XXs",
       "totalInDatabase": 121
     }
   }
   ```

2. **Verify in Supabase**:
   - Go to Supabase Dashboard → Table Editor
   - Select `products` table
   - Verify 121 products are present

3. **Test Live Site**:
   - Visit `https://your-vercel-url.vercel.app`
   - Products should display on homepage
   - Test product pages and cart functionality

## 📊 What Gets Deployed

### Files Included
- ✅ All HTML pages (index, admin, auth, product-view)
- ✅ JavaScript files (cart, products-loader, supabase-config)
- ✅ Product data (products-cleaned.json)
- ✅ Static assets (images, CSS from pettikadai.in)
- ✅ API endpoints (seed-products)

### Products Seeded
- **Total**: 121 valid products
- **Categories**:
  - Other: 80 products
  - Snacks: 16 products
  - Sweets: 15 products
  - Groceries: 10 products

## 🔒 Security Notes

> [!WARNING]
> After seeding is complete, consider restoring the restrictive RLS policy:

```sql
DROP POLICY IF EXISTS "Allow anon inserts for seeding" ON products;
CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

## 🎯 Post-Deployment Checklist

- [ ] Deployment successful on Vercel
- [ ] Products seeded (121 products)
- [ ] Homepage displays products
- [ ] Product pages load correctly
- [ ] Cart functionality works
- [ ] Images load properly
- [ ] RLS policies restored (optional)
- [ ] Custom domain configured (optional)

## 🔄 Continuous Deployment

Any push to the `main` branch will automatically redeploy:

```bash
git add .
git commit -m "Update description"
git push origin main
```

## 🆘 Troubleshooting

### Seeding Fails
- **Check RLS Policies**: Ensure "Allow anon inserts" policy is active
- **Check Logs**: View Vercel function logs in dashboard
- **Verify Supabase**: Ensure database is accessible

### Products Don't Display
- **Check Console**: Open browser DevTools → Console
- **Verify API**: Check `supabase-config.js` has correct credentials
- **Check Network**: Ensure Supabase requests succeed

### Deployment Fails
- **Check Build Logs**: View in Vercel dashboard
- **Verify Files**: Ensure all files are committed to Git
- **Check package.json**: Ensure dependencies are correct

## 📞 Support Resources

- **Vercel Docs**: [vercel.com/docs](https://vercel.com/docs)
- **Supabase Docs**: [supabase.com/docs](https://supabase.com/docs)
- **Vercel Dashboard**: Check deployment logs and analytics

---

## 🎉 Success!

Your GKR Sweets e-commerce site is now live on Vercel with all products seeded!

**Next Steps**:
- Share your Vercel URL
- Configure custom domain (optional)
- Test all e-commerce functionality
- Monitor analytics in Vercel dashboard
