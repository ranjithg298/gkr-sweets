const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');

// Supabase Config
const SUPABASE_URL = 'https://mamsjkoxduulgveshdcf.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hbXNqa294ZHV1bGd2ZXNoZGNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MjY3NzEsImV4cCI6MjA3OTQwMjc3MX0.rk2qTSXHJbdR23Buesz7kEV0CCk9IJP961Ym2TyWFEo';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

const SITES = [
    {
        name: 'enchipsu',
        path: 'c:\\My Web Sites\\enchipsu\\enchipsu.com\\products',
        urlPrefix: 'https://enchipsu.com/products/'
    },
    {
        name: 'oorla',
        path: 'c:\\My Web Sites\\oorla\\www.oorla.in\\products',
        urlPrefix: 'https://www.oorla.in/products/'
    },
    {
        name: 'purleysouth',
        path: 'c:\\My Web Sites\\purleysouth\\purelysouth.com\\products',
        urlPrefix: 'https://purelysouth.com/products/'
    }
];

const GKR_PRODUCTS_PATH = 'c:\\My Web Sites\\gkr sweet\\products.json';

function extractJsonFromHtml(html) {
    let match = html.match(/AVADA_CDT\.product\s*=\s*(\{[\s\S]*?\});/);
    if (match) {
        try { return JSON.parse(match[1]); } catch (e) { }
    }
    match = html.match(/var meta\s*=\s*(\{[\s\S]*?\});/);
    if (match) {
        try {
            const meta = JSON.parse(match[1]);
            if (meta.product) return meta.product;
        } catch (e) { }
    }
    return null;
}

function normalizeProduct(raw, site) {
    if (!raw) return null;

    const id = raw.id || raw.product_id;
    const title = raw.title || raw.name;
    const handle = raw.handle || raw.slug;

    let price = raw.price;
    if (price > 1000) price = price / 100;

    let images = [];
    if (raw.images && Array.isArray(raw.images)) {
        images = raw.images.map(img => typeof img === 'string' ? img : (img.src || img));
    } else if (raw.featured_image) {
        images = [raw.featured_image];
    } else if (raw.image) {
        images = [raw.image.src || raw.image];
    }

    images = images.map(img => {
        if (img && img.startsWith('//')) return 'https:' + img;
        return img;
    });

    return {
        slug: `${site.name}-${handle}`, // Ensure unique slug
        name: title,
        description: raw.description || '',
        price: price,
        category: raw.type || raw.category || 'General',
        images: images,
        active: true,
        tags: [site.name, 'aggregated'], // Store vendor in tags
        sku: `${site.name}-${id}`
    };
}

async function main() {
    let allProducts = [];

    // 1. Process GKR Sweet
    if (fs.existsSync(GKR_PRODUCTS_PATH)) {
        console.log('Processing GKR Sweet...');
        try {
            const gkrData = JSON.parse(fs.readFileSync(GKR_PRODUCTS_PATH, 'utf8'));
            const gkrProducts = gkrData.map(p => ({
                slug: `gkr-${p.slug}`,
                name: p.name,
                description: p.description,
                price: p.price,
                category: p.category,
                images: p.images,
                active: true,
                tags: ['GKR Sweet', 'aggregated'],
                sku: `gkr-${p.slug}`
            }));
            allProducts = allProducts.concat(gkrProducts);
        } catch (e) {
            console.error('Error reading GKR products:', e);
        }
    }

    // 2. Process other sites
    for (const site of SITES) {
        console.log(`Processing ${site.name}...`);
        if (!fs.existsSync(site.path)) {
            console.warn(`Path not found: ${site.path}`);
            continue;
        }

        const files = fs.readdirSync(site.path);
        for (const file of files) {
            if (!file.endsWith('.html')) continue;

            const filePath = path.join(site.path, file);
            const html = fs.readFileSync(filePath, 'utf8');
            const json = extractJsonFromHtml(html);

            if (json) {
                const product = normalizeProduct(json, site);
                if (product) {
                    allProducts.push(product);
                }
            }
        }
    }

    console.log(`Total products to insert: ${allProducts.length}`);

    // Authenticate first to bypass RLS
    const email = 'admin@gkrsweets.com';
    const password = 'tempPassword123!';

    console.log('Attempting to sign in...');
    let { data, error: authError } = await supabase.auth.signInWithPassword({
        email,
        password
    });

    if (authError) {
        console.log('Sign in failed:', authError.message);
        console.log('Attempting to sign up...');
        const { data: signUpData, error: signUpError } = await supabase.auth.signUp({
            email,
            password
        });
        if (signUpError) {
            console.error('Sign up failed:', signUpError.message);
        } else {
            console.log('Sign up successful. Session:', !!signUpData.session);
            if (signUpData.session) {
                data = signUpData;
            } else {
                console.log('User created but no session (check email confirmation).');
            }
        }
    } else {
        console.log('Sign in successful.');
    }

    if (data && data.session) {
        console.log('Authenticated as:', data.session.user.email);
        // Explicitly set session just in case
        await supabase.auth.setSession(data.session);
    } else {
        console.warn('Proceeding without session (RLS WILL FAIL)...');
    }

    // 3. Insert into Supabase
    const CHUNK_SIZE = 50;
    for (let i = 0; i < allProducts.length; i += CHUNK_SIZE) {
        const chunk = allProducts.slice(i, i + CHUNK_SIZE);
        const { error } = await supabase
            .from('products')
            .upsert(chunk, { onConflict: 'slug' });

        if (error) {
            console.error(`Error inserting chunk ${i}:`, error);
        } else {
            console.log(`Inserted chunk ${i} to ${i + chunk.length}`);
        }
    }

    console.log('Done seeding Supabase.');
}

main();
