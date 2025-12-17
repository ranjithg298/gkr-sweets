const fs = require('fs');
const path = require('path');

const productsDir = path.join(__dirname, 'pettikadai.in', 'products');
const outputFile = path.join(__dirname, 'products.json');

// Helper to extract meta content
function getMeta(html, property) {
    const regex = new RegExp(`<meta property="${property}" content="([^"]*)"`, 'i');
    const match = html.match(regex);
    return match ? match[1] : '';
}

function decodeHtml(html) {
    return html.replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"')
        .replace(/&#039;/g, "'");
}

try {
    const files = fs.readdirSync(productsDir);
    const products = [];

    console.log(`Found ${files.length} files.`);

    files.forEach(file => {
        if (!file.endsWith('.html')) return;

        const filePath = path.join(productsDir, file);
        const content = fs.readFileSync(filePath, 'utf-8');
        const slug = file.replace('.html', '');

        const name = getMeta(content, 'og:title') || slug;
        const priceStr = getMeta(content, 'og:price:amount');
        const price = priceStr ? parseFloat(priceStr) : 0;
        const description = getMeta(content, 'og:description') || '';
        let image = getMeta(content, 'og:image') || '';

        // Fix image URL if it's http
        if (image.startsWith('http://')) {
            image = image.replace('http://', 'https://');
        }

        // Infer category from title or description
        let category = 'Other';
        const lowerName = name.toLowerCase();
        if (lowerName.includes('sweet') || lowerName.includes('mysorepak') || lowerName.includes('halwa') || lowerName.includes('laddu')) category = 'Sweets';
        else if (lowerName.includes('snack') || lowerName.includes('muruku') || lowerName.includes('mixture') || lowerName.includes('sev')) category = 'Snacks';
        else if (lowerName.includes('oil') || lowerName.includes('ghee')) category = 'Groceries';
        else if (lowerName.includes('pickle') || lowerName.includes('thokku')) category = 'Pickles';

        products.push({
            name: decodeHtml(name),
            slug: slug,
            description: decodeHtml(description),
            price: price,
            category: category,
            images: [image],
            active: true,
            weight: '1 kg', // Default, hard to extract reliably without more parsing
            stock: 100
        });
    });

    fs.writeFileSync(outputFile, JSON.stringify(products, null, 2));
    console.log(`Successfully extracted ${products.length} products to products.json`);

} catch (err) {
    console.error('Error:', err);
}
