# GKR Sweets - Complete Deployment Guide

## 📋 Overview

This guide will walk you through deploying GKR Sweets to Vercel with Firebase integration.

## 🔥 Firebase Setup (Already Configured)

Your Firebase project is already set up with the following credentials:
- **Project ID**: gkr-sweets
- **Auth Domain**: gkr-sweets.firebaseapp.com
- **Storage Bucket**: gkr-sweets.firebasestorage.app

### Required Firebase Services

1. **Authentication** ✅
   - Email/Password authentication
   - Google Sign-In provider
   
2. **Firestore Database** (Need to enable)
   - Go to Firebase Console → Firestore Database
   - Click "Create Database"
   - Start in **production mode**
   - Choose your preferred location (asia-south1 recommended for India)

3. **Storage** (Need to enable)
   - Go to Firebase Console → Storage
   - Click "Get Started"
   - Start in **production mode**
   - This will store product images

### Firebase Security Rules

#### Firestore Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

#### Storage Rules
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 🚀 Vercel Deployment

### Step 1: Push to GitHub ✅

Your code is being pushed to: https://github.com/ranjithg298/gkr-sweets

### Step 2: Deploy to Vercel

1. Go to [Vercel](https://vercel.com)
2. Sign in with your GitHub account
3. Click "Add New Project"
4. Import `ranjithg298/gkr-sweets` repository
5. Configure project:
   - **Framework Preset**: Other
   - **Root Directory**: ./
   - **Build Command**: (leave empty)
   - **Output Directory**: (leave empty)
6. Click "Deploy"

### Step 3: Configure Custom Domain (Optional)

1. In Vercel dashboard, go to your project
2. Click "Settings" → "Domains"
3. Add your custom domain
4. Follow DNS configuration instructions

## 🔐 Admin Panel Access

### Creating Admin Users

1. Go to your deployed site: `https://your-site.vercel.app/auth.html`
2. Register with your admin email
3. Or use Google Sign-In

### Accessing Admin Panel

- URL: `https://your-site.vercel.app/admin.html`
- Requires authentication
- Upload products, manage inventory

## 📱 Google APIs Integration

### Google Analytics (Already Configured)

Your site already has Google Analytics configured:
- GA4 ID: G-6S020KECR4
- Google Ads: AW-832426439

### Additional Google Services

1. **Google Search Console**
   - Add your Vercel domain
   - Verify ownership using the meta tag already in the HTML
   - Submit sitemap

2. **Google My Business**
   - Create business listing
   - Add your website URL
   - Verify business

## 🎨 Rebranding Status

### Completed ✅
- Firebase configuration updated to "GKR Sweets"
- Admin panel branded as "GKR Sweets"
- Authentication pages branded as "GKR Sweets"

### To Complete 📝
- Update all text references from "Pettikadai" to "GKR Sweets" in HTML files
- Update meta tags and SEO content
- Keep all product images as-is

## 🛠️ Post-Deployment Tasks

1. **Test Authentication**
   - Register a new account
   - Login with email/password
   - Test Google Sign-In

2. **Test Admin Panel**
   - Upload a test product
   - Verify image upload to Firebase Storage
   - Check Firestore database

3. **Test E-commerce Flow**
   - Browse products
   - Add to cart
   - Checkout process

4. **SEO Optimization**
   - Update meta descriptions
   - Add structured data
   - Submit to search engines

## 📊 Monitoring

### Vercel Analytics
- Automatically enabled
- View in Vercel dashboard

### Firebase Analytics
- Already configured
- View in Firebase Console

### Google Analytics
- Track user behavior
- Monitor conversions

## 🔄 Continuous Deployment

Any push to the `main` branch will automatically deploy to Vercel.

To update your site:
```bash
git add .
git commit -m "Your update message"
git push origin main
```

## 🆘 Troubleshooting

### Firebase Authentication Issues
- Check Firebase Console → Authentication → Sign-in methods
- Ensure Email/Password and Google are enabled
- Verify authorized domains include your Vercel domain

### Image Upload Issues
- Check Firebase Storage rules
- Verify Storage is enabled
- Check browser console for errors

### Deployment Issues
- Check Vercel deployment logs
- Verify all files are committed to Git
- Check vercel.json configuration

## 📞 Support

For issues or questions:
- Check Firebase Console for service status
- Review Vercel deployment logs
- Check browser console for errors

---

**Deployment Checklist:**
- [x] Firebase project created
- [x] Authentication enabled
- [ ] Firestore Database enabled
- [ ] Storage enabled
- [ ] Security rules configured
- [x] Code pushed to GitHub
- [ ] Deployed to Vercel
- [ ] Custom domain configured (optional)
- [ ] Admin user created
- [ ] Test product uploaded
- [ ] Google Search Console verified

---

Made with ❤️ for GKR Sweets
