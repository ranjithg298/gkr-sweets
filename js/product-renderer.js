import { checkout } from './payment.js';

/**
 * Renders a product card for the main grid layout (e.g., Best Sellers, Vegan Picks).
 * @param {Object} product - The product object from Supabase.
 * @returns {string} - The HTML string for the product card.
 */
export function renderProductCard(product) {
    // Fallback for image
    const imageUrl = product.image_url || 'https://cdn.shopify.com/s/images/themes/product-1.png';
    const price = parseFloat(product.price).toFixed(2);

    return `
    <div class="col-md-3 col-sm-6 col-xs-6 collection-products-wrapper">
        <div class="product-thumb">
            <a class="product-thumb-href" href="product-view.html?id=${product.slug}"></a>
            <div class="product-thumb-inner">
                <div class="product-thumb-img-wrap">
                    <img class="product-thumb-img" src="${imageUrl}" alt="${product.name}" style="max-width: 100%; height: auto;">
                </div>
            </div>
            <div class="product-thumb-caption">
                <h5 class="product-thumb-caption-title">${product.name}</h5>
                <div class="Main-Product-price"><span class="money">₹ ${price}</span></div>
                <div class="collection-button">
                    <button class="btn collection-btn add-to-cart-btn" data-product-id="${product.id}">
                        <span class="addtocart-btn-text">ADD</span>
                    </button>
                    <button class="btn collection-btn buy-now-btn" onclick="checkout({name: '${product.name.replace(/'/g, "\\'")}', price: ${product.price}})">
                        Buy Now
                    </button>
                </div>
            </div>
        </div>
    </div>
    `;
}

/**
 * Renders a product card for the "Explore Our Collections" scroll container.
 * @param {Object} product - The product object from Supabase.
 * @returns {string} - The HTML string for the product card.
 */
export function renderCollectionCard(product) {
    const imageUrl = product.image_url || 'https://cdn.shopify.com/s/images/themes/product-1.png';
    const price = parseFloat(product.price).toFixed(2);

    return `
    <div class="product-card fade-in">
        <a href="product-view.html?id=${product.slug}">
            <img src="${imageUrl}" alt="${product.name}">
            <h4>${product.name}</h4>
            <p><span class="money">₹ ${price}</span></p>
        </a>
        <button class="btn btn-primary btn-block add-to-cart-btn" data-product-id="${product.id}">
            Add to cart
        </button>
        <button class="btn btn-secondary btn-block buy-now-btn" style="margin-top: 5px;" onclick="checkout({name: '${product.name.replace(/'/g, "\\'")}', price: ${product.price}})">
            Buy Now
        </button>
    </div>
    `;
}

/**
 * Renders a grid of products into a container.
 * @param {string} containerId - The ID of the container element.
 * @param {Array} products - Array of product objects.
 * @param {Function} renderFn - The render function to use (renderProductCard or renderCollectionCard).
 */
export function renderProductGrid(containerId, products, renderFn = renderProductCard) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.warn(`Container with ID '${containerId}' not found.`);
        return;
    }

    if (!products || products.length === 0) {
        container.innerHTML = '<p class="text-center">No products found.</p>';
        return;
    }

    container.innerHTML = products.map(product => renderFn(product)).join('');
}
