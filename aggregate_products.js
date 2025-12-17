const fs = require('fs');
const path = require('path');

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
const OUTPUT_PATH = 'c:\\My Web Sites\\gkr sweet\\aggregator_app\\public\\products.json'; // Will write here once dir exists

function extractJsonFromHtml(html) {
    // Try AVADA_CDT.product
    let match = html.match(/AVADA_CDT\.product\s*=\s*(\{[\s\S]*?\});/);
    if (match) {
        try {
            return JSON.parse(match[1]);
        } catch (e) {
            // console.error('Failed to parse AVADA_CDT JSON', e);
        }
    }

    // Try ShopifyAnalytics.meta
    match = html.match(/var meta\s*=\s*(\{[\s\S]*?\});/);
    if (match) {
        try {
            const meta = JSON.parse(match[1]);
            if (meta.product) return meta.product;
        } catch (e) {
            // console.error('Failed to parse ShopifyAnalytics JSON', e);
        }
    }

    return null;
}

function normalizeProduct(raw, site) {
    if (!raw) return null;

    // Handle different structures
    const id = raw.id || raw.product_id;
    const title = raw.title || raw.name;
    const handle = raw.handle || raw.slug;

    // Price: raw.price is usually in cents for Shopify (e.g. 12500 for 125.00)
    // But check if it's already normalized
    let price = raw.price;
    if (price > 1000) { // Assumption: prices > 1000 are likely in cents if the item isn't super expensive
        // Actually, let's look at the data. 12500 for 125.00 INR. So divide by 100.
        price = price / 100;
    }

    // Images
    let images = [];
    if (raw.images && Array.isArray(raw.images)) {
        images = raw.images.map(img => {
            if (typeof img === 'string') return img;
            return img.src || img;
        });
    } else if (raw.featured_image) {
        images = [raw.featured_image];
    } else if (raw.image) {
        images = [raw.image.src || raw.image];
    }

    // Fix relative image URLs
    images = images.map(img => {
        if (img && img.startsWith('//')) return 'https:' + img;
        return img;
    });

    return {
        id: `${site.name}-${id}`,
        originalId: id,
        title: title,
        handle: handle,
        vendor: site.name,
        price: price,
        images: images,
        url: site.urlPrefix + handle,
        description: raw.description || '', // Description might be missing in JSON
        category: raw.type || raw.category || 'General'
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
                id: `gkr-${p.slug}`, // Use slug as ID if no ID
                originalId: p.slug,
                title: p.name,
                handle: p.slug,
                vendor: 'GKR Sweet',
                price: p.price,
                images: p.images,
                url: `https://pettikadai.in/products/${p.slug}`, // Assuming URL
                description: p.description,
                category: p.category
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

    console.log(`Total products aggregated: ${allProducts.length}`);

    // Ensure output dir exists
    const outputDir = path.dirname(OUTPUT_PATH);
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    fs.writeFileSync(OUTPUT_PATH, JSON.stringify(allProducts, null, 2));
    console.log(`Wrote products to ${OUTPUT_PATH}`);
}

main();
