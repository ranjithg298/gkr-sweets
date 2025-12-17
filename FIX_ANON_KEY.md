# How to Get Your Correct Supabase Anon Key

## The Error You're Seeing

**"JWT failed verification"** means the anon key in `supabase-config.js` doesn't match your project.

## Quick Fix (2 minutes)

### Step 1: Get Your Real Anon Key

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: **project-f9153bb7-8dba-450a-831**
3. Click **Settings** (gear icon) in the left sidebar
4. Click **API** 
5. Find the section **Project API keys**
6. Copy the **anon** **public** key (it's a long string starting with `eyJ...`)

### Step 2: Update supabase-config.js

1. Open `supabase-config.js`
2. Find line 5 (the `supabaseAnonKey` line)
3. Replace the entire key with your copied key
4. Save the file

It should look like this:

```javascript
const supabaseAnonKey = 'eyJhbGc... YOUR ACTUAL KEY HERE ...';
```

### Step 3: Test Again

1. Refresh your browser
2. Try the SQL query again
3. Try logging in to auth.html

## Important Notes

- The anon key is **safe to use in frontend code**
- It's called "anon" because it has limited permissions
- Each Supabase project has a unique anon key
- The old key was from a different project, that's why it failed

## Need Help?

If you can't find the key, just tell me and I'll guide you step-by-step!
