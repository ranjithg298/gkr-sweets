const fs = require('fs');
const path = require('path');

// Configuration
const SITE_ROOT = path.resolve(__dirname, '..'); // c:/My Web Sites
const OUTPUT_FILE = path.join(__dirname, 'products-data.js');

const SOURCES = [
    {
        name: 'oorla',
        path: path.join(SITE_ROOT, 'oorla', 'www.oorla.in', 'products'),
        urlPrefix: '../oorla/www.oorla.in/products/'
    },
    {
        name: 'purleysouth',
        path: path.join(SITE_ROOT, 'purleysouth', 'purelysouth.com', 'products'),
        urlPrefix: '../purleysouth/purelysouth.com/products/'
    },
    {
        name: 'enchipsu',
        path: path.join(SITE_ROOT, 'enchipsu', 'enchipsu.com', 'products'),
        urlPrefix: '../enchipsu/enchipsu.com/products/'
    },
    {
        name: 'pettikadai',
        path: path.join(__dirname, 'pettikadai.in', 'products'), // Local path in gkr sweet
        urlPrefix: 'pettikadai.in/products/'
    }
];

function formatProductName(filename) {
    // Remove extension
    const name = path.parse(filename).name;
    // Replace hyphens with spaces and Title Case
    return name
        .replace(/-/g, ' ')
        .replace(/\b\w/g, char => char.toUpperCase());
}

function generateData() {
    let allProducts = [];

    SOURCES.forEach(source => {
        try {
            if (!fs.existsSync(source.path)) {
                console.warn(`Warning: Directory not found: ${source.path}`);
                return;
            }

            const files = fs.readdirSync(source.path);
            const products = files
                .filter(file => file.endsWith('.html') && !file.includes('GET') && !file.includes('POST'))
                .map(file => {
                    return {
                        id: `${source.name}-${path.parse(file).name}`,
                        name: formatProductName(file),
                        url: source.urlPrefix + file,
                        source: source.name,
                        image: 'https://via.placeholder.com/300x300?text=' + source.name // Placeholder, ideally we'd scrape the HTML for og:image
                    };
                });

            console.log(`Found ${products.length} products in ${source.name}`);
            allProducts = allProducts.concat(products);

        } catch (err) {
            console.error(`Error processing ${source.name}:`, err.message);
        }
    });

    const fileContent = `// Auto-generated product data
export const products = ${JSON.stringify(allProducts, null, 4)};
`;

    fs.writeFileSync(OUTPUT_FILE, fileContent);
    console.log(`Successfully wrote ${allProducts.length} products to ${OUTPUT_FILE}`);
}

generateData();
