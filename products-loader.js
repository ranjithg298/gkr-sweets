import { products as staticProducts } from './products-data.js';
import { addToCart } from './cart.js';

export async function loadProducts(containerId) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.error(`Container with ID '${containerId}' not found.`);
        return;
    }

    // Show loading state
    container.innerHTML = '<div class="col-xs-12 text-center"><p>Loading GKR Sweets...</p></div>';

    // Use static data directly
    const data = staticProducts;

    if (!data || data.length === 0) {
        container.innerHTML = '<div class="col-xs-12 text-center"><p class="empty">No products found.</p></div>';
        return;
    }

    // Clear container
    container.innerHTML = '';

    // Render products
    const productHTML = data.map(product => {
        // Use the first image or a placeholder
        const imageUrl = product.image || 'https://via.placeholder.com/300x300?text=GKR+Sweets';

        // Format price (Mock price for now as static data might not have it, defaulting to 100)
        const price = "100.00";

        return `
        <div class="col-md-3 col-sm-6 col-xs-3 collection-products-wrapper Override-bootstrap-res">
            <div class="product-thumb">
                <a class="product-thumb-href" href="${product.url}"></a>
                
                <div class="product-thumb-inner">
                    <div class="product-thumb-img-wrap">
                        <img class="product-thumb-img" src="${imageUrl}" alt="${product.name}" style="max-width: 100%; height: auto;">
                    </div>
                </div>
                
                <div class="product-thumb-caption" data-title="${product.name}">
                    <h5 class="product-thumb-caption-title for-desktop-title">${product.name}</h5>
                    <h5 class="product-thumb-caption-title for-mobile-title">${product.name}</h5>
                    
                    <div class="selectBox-with-popup">
                        <div class="Main-Product-price"><span class="money">₹ ${price}</span></div>
                    </div>

                    <div class="Quantity-selector-with-button">
                        <div class="collection-Quantity-selector">
                            <div class="Quantity-text">Qty</div>
                            <input type="number" id="qty-${product.id}" name="quantity" min="1" value="1" class="collection-input-number">
                        </div>
                        <div class="collection-button">
                            <button class="btn collection-btn" onclick="window.cartModule.addToCart('${product.id}', document.getElementById('qty-${product.id}').value)">
                                <span class="addtocart-btn-text">ADD</span>
                                <span class="Cart-icon"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        `;
    }).join('');

    container.innerHTML = productHTML;
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    // The container ID in index.html is 'filter-row'
    loadProducts('filter-row');
});
