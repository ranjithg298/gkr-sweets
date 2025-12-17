
import { products, cart } from '../supabase-config.js';
import { renderProductGrid, renderProductCard, renderCollectionCard } from './product-renderer.js';

// Helper to get or create a session ID for the cart
function getSessionId() {
    let sessionId = localStorage.getItem('cart_session_id');
    if (!sessionId) {
        sessionId = crypto.randomUUID();
        localStorage.setItem('cart_session_id', sessionId);
    }
    return sessionId;
}

async function addToCart(productId) {
    const sessionId = getSessionId();
    // Default quantity 1 for now
    const { data, error } = await cart.addItem(sessionId, productId, 1);

    if (error) {
        console.error('Error adding to cart:', error);
        alert('Failed to add to cart. Please try again.');
    } else {
        console.log('Added to cart:', data);
        alert('Product added to cart!');
        // Optionally update cart count here
    }
}

const PLACEHOLDER_PRODUCTS = [
    { id: 'p1', name: 'Classic Mysore Pak', category: 'Sweets', price: 450, image_url: 'https://placehold.co/400x300?text=Mysore+Pak', slug: 'classic-mysore-pak' },
    { id: 'p2', name: 'Spicy Murukku', category: 'Savouries', price: 120, image_url: 'https://placehold.co/400x300?text=Murukku', slug: 'spicy-murukku' },
    { id: 'p3', name: 'Mixed Sweets Combo', category: 'Combos', price: 999, image_url: 'https://placehold.co/400x300?text=Sweets+Combo', slug: 'mixed-sweets-combo' },
    { id: 'p4', name: 'Banana Chips', category: 'Savouries', price: 150, image_url: 'https://placehold.co/400x300?text=Banana+Chips', slug: 'banana-chips' },
    { id: 'p5', name: 'Ghee Laddu', category: 'Sweets', price: 350, image_url: 'https://placehold.co/400x300?text=Laddu', slug: 'ghee-laddu' }
];

async function loadSection(category, containerId, renderFn) {
    let { data, error } = await products.getByCategory(category);

    if (error || !data || data.length === 0) {
        console.warn(`Error fetching ${category} or no data, using placeholders.`, error);
        // Filter placeholders by category roughly
        data = PLACEHOLDER_PRODUCTS.filter(p => p.category === category || category === 'Sweets');
        if (data.length === 0) data = PLACEHOLDER_PRODUCTS;
    }
    renderProductGrid(containerId, data, renderFn);
}

export async function initHomePage() {
    console.log('Initializing Homepage Products...');

    // Load "Our Vegan Picks" (Assuming category 'Vegan')
    await loadSection('Vegan', 'vegan-picks-container', renderProductCard);

    // Load "Best Sellers" (Assuming category 'Sweets' for now, or we could fetch all and slice)
    // For now, let's try fetching 'Sweets' as best sellers
    await loadSection('Sweets', 'best-sellers-container', renderProductCard);

    // Load Collections
    await loadSection('Oil', 'oil-collection-container', renderCollectionCard);
    await loadSection('Honey', 'honey-collection-container', renderCollectionCard);
    await loadSection('Groceries', 'groceries-collection-container', renderCollectionCard);

    // Attach Event Listeners for Add to Cart
    document.addEventListener('click', async (e) => {
        if (e.target.closest('.add-to-cart-btn')) {
            const button = e.target.closest('.add-to-cart-btn');
            const productId = button.dataset.productId;
            if (productId) {
                await addToCart(productId);
            }
        }
    });
}

// Auto-initialize if running on the client
if (typeof window !== 'undefined') {
    window.addEventListener('DOMContentLoaded', initHomePage);
}
