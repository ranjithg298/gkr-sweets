# Supabase Setup Guide for GKR Sweets

## ✅ Configuration Complete

Your Supabase integration has been successfully configured!

### 📋 Credentials
- **Supabase URL**: `https://mamsjkoxduulgveshdcf.supabase.co`
- **Anon Key**: Configured in `supabase-config.js`

### 📁 Files Created/Updated

1. **supabase-config.js** - Main configuration file with helper functions
2. **auth.html** - Updated to use Supabase authentication
3. **admin.html** - Needs to be updated (see below)

### 🔧 Next Steps

#### 1. Set up Supabase Database Tables

Log into your Supabase dashboard and create the following tables:

**Products Table:**
```sql
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  images TEXT[] NOT NULL,
  created_by TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can view products" ON products
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update their own products" ON products
  FOR UPDATE USING (auth.email() = created_by);

CREATE POLICY "Users can delete their own products" ON products
  FOR DELETE USING (auth.email() = created_by);
```

#### 2. Set up Storage Bucket

1. Go to **Storage** in your Supabase dashboard
2. Create a new bucket called `products`
3. Set it to **Public** (or configure policies as needed)
4. Configure the following policy:

```sql
-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload product images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'products');

-- Allow anyone to view product images
CREATE POLICY "Anyone can view product images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'products');
```

#### 3. Enable Google OAuth (Optional)

1. Go to **Authentication** → **Providers** in Supabase dashboard
2. Enable **Google** provider
3. Add your Google OAuth credentials:
   - Client ID
   - Client Secret
4. Add authorized redirect URLs:
   - `https://mamsjkoxduulgveshdcf.supabase.co/auth/v1/callback`
   - Your production domain callback URL

#### 4. Configure Email Templates

1. Go to **Authentication** → **Email Templates**
2. Customize the email verification template
3. Set your site URL in **Authentication** → **URL Configuration**

### 🎯 Features Implemented

#### Authentication (`auth.html`)
- ✅ Email/Password registration
- ✅ Email/Password login
- ✅ Google OAuth integration
- ✅ Email verification
- ✅ Error handling
- ✅ Success messages

#### Configuration (`supabase-config.js`)
- ✅ Supabase client initialization
- ✅ Auth helper functions
- ✅ Storage helper functions
- ✅ Database helper functions

### 📝 Usage Examples

#### Sign Up
```javascript
import { auth } from './supabase-config.js';

const { data, error } = await auth.signUp(email, password, {
  full_name: 'John Doe'
});
```

#### Sign In
```javascript
const { data, error } = await auth.signIn(email, password);
```

#### Upload Image
```javascript
import { storage } from './supabase-config.js';

const { data, error } = await storage.upload(
  'products',
  `${Date.now()}_image.jpg`,
  file
);

const publicUrl = storage.getPublicUrl('products', data.path);
```

#### Add Product
```javascript
import { db } from './supabase-config.js';

const { data, error } = await db.insert('products', {
  name: 'Mysore Pak',
  category: 'sweets',
  description: 'Traditional South Indian sweet',
  price: 250.00,
  images: [imageUrl1, imageUrl2],
  created_by: user.email
});
```

### 🔄 Migration from Firebase

The following files still use Firebase and need to be updated:
- ❌ `admin.html` - Update to use Supabase
- ❌ `firebase-config.js` - Can be removed after migration

### 🚀 Testing

1. Open `auth.html` in your browser
2. Try registering a new account
3. Check your email for verification
4. Try logging in
5. Test Google OAuth (after configuration)

### 🔒 Security Notes

- Never commit your Supabase keys to public repositories
- Use environment variables for production
- Enable Row Level Security (RLS) on all tables
- Configure proper storage policies
- Regularly rotate your service role key

### 📚 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Supabase Storage](https://supabase.com/docs/guides/storage)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

**Need Help?** Check the Supabase dashboard logs for debugging authentication and database issues.
