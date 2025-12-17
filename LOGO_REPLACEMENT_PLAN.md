# Logo Replacement Script

## Files to Update

### 1. Main Index File
**File:** `pettikadai.in/indexab3f.html`

**Replacements needed:**
- Line 463: Favicon
- Line 631: Multiple logo references in settings JSON
- Header logo (need to find)
- Footer logo (need to find)

### 2. Search and Replace

**Old References:**
```
pettikadai-logo-final.png
pettikadai-logo-final_32x32
cdn/shop/files/pettikadai-logo-final
```

**New References:**
```
gkr-logo.png
../gkr-logo.png
```

### 3. Text Replacements

**Old:** Pettikadai
**New:** GKR Sweets

**Old:** pettikadai.in
**New:** GKR Sweets

## Manual Steps Required

Due to the complexity and size of `indexab3f.html` (6660 lines), I recommend:

1. **Create a new simplified homepage** instead
2. **Or** use find-replace in your editor:
   - Find: `pettikadai-logo-final`
   - Replace: `gkr-logo`
   
3. **Update meta tags:**
   - Title: "GKR Sweets - Traditional Indian Sweets & Snacks"
   - Description: Update to GKR Sweets

## Better Approach

I'll create a NEW clean homepage that:
- Uses GKR branding
- Loads products from Supabase
- Has working cart
- Is much simpler and faster

**New file:** `index-new.html`

This way:
- Old site stays intact
- New site is clean and modern
- Easy to test
- Easy to switch over

## Decision Point

Would you prefer:
1. **Clean new homepage** (recommended) - 30 min
2. **Fix existing complex file** - risky, 2+ hours

Let me know!
