import { cart } from './supabase-config.js';

// Cart State
let cartState = {
    items: [],
    total: 0,
    count: 0
};

// Initialize Cart
export async function initCart() {
    const sessionId = localStorage.getItem('sessionId') || generateSessionId();
    await loadCart(sessionId);
    updateCartUI();
    setupCartListeners();
}

// Generate Session ID
function generateSessionId() {
    const id = 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    localStorage.setItem('sessionId', id);
    return id;
}

// Load Cart from Supabase
async function loadCart(sessionId) {
    const { data, error } = await cart.getCart(sessionId);
    if (error) {
        console.error('Error loading cart:', error);
        return;
    }

    cartState.items = data || [];
    calculateTotals();
}

// Calculate Totals
function calculateTotals() {
    cartState.count = cartState.items.reduce((sum, item) => sum + item.quantity, 0);
    cartState.total = cartState.items.reduce((sum, item) => sum + (item.products.price * item.quantity), 0);
}

// Add to Cart
export async function addToCart(productId) {
    const sessionId = localStorage.getItem('sessionId');
    if (!sessionId) return;

    // Optimistic UI update
    // (Real implementation would wait, but for speed we can show success immediately)

    const { error } = await cart.addItem(sessionId, productId, 1);

    if (error) {
        alert('Error adding to cart');
        return;
    }

    await loadCart(sessionId);
    updateCartUI();
    openCart();
}

// Remove from Cart
export async function removeFromCart(itemId) {
    const { error } = await cart.removeItem(itemId);
    if (error) {
        console.error('Error removing item:', error);
        return;
    }

    const sessionId = localStorage.getItem('sessionId');
    await loadCart(sessionId);
    updateCartUI();
}

// Update Quantity
export async function updateQuantity(itemId, newQuantity) {
    if (newQuantity < 1) return;

    const { error } = await cart.updateQuantity(itemId, newQuantity);
    if (error) {
        console.error('Error updating quantity:', error);
        return;
    }

    const sessionId = localStorage.getItem('sessionId');
    await loadCart(sessionId);
    updateCartUI();
}

// Update UI
function updateCartUI() {
    // Update Badge
    const badges = document.querySelectorAll('.cart-count-badge');
    badges.forEach(badge => badge.textContent = cartState.count);

    // Update Modal Content
    const cartItemsContainer = document.getElementById('cart-items-container');
    if (cartItemsContainer) {
        if (cartState.items.length === 0) {
            cartItemsContainer.innerHTML = '<p class="empty-cart">Your cart is empty</p>';
        } else {
            cartItemsContainer.innerHTML = cartState.items.map(item => `
                <div class="cart-item">
                    <img src="${item.products.images[0]}" alt="${item.products.name}" class="cart-item-img">
                    <div class="cart-item-details">
                        <h4>${item.products.name}</h4>
                        <p>₹${item.products.price}</p>
                        <div class="quantity-controls">
                            <button onclick="window.cartModule.updateQuantity('${item.id}', ${item.quantity - 1})">-</button>
                            <span>${item.quantity}</span>
                            <button onclick="window.cartModule.updateQuantity('${item.id}', ${item.quantity + 1})">+</button>
                        </div>
                    </div>
                    <button class="remove-btn" onclick="window.cartModule.removeFromCart('${item.id}')">&times;</button>
                </div>
            `).join('');
        }
    }

    // Update Total
    const totalEl = document.getElementById('cart-total-price');
    if (totalEl) {
        totalEl.textContent = '₹' + cartState.total;
    }
}

// UI Helpers
function openCart() {
    document.getElementById('cart-modal').classList.add('active');
    document.getElementById('cart-overlay').classList.add('active');
}

function closeCart() {
    document.getElementById('cart-modal').classList.remove('active');
    document.getElementById('cart-overlay').classList.remove('active');
}

function setupCartListeners() {
    const overlay = document.getElementById('cart-overlay');
    if (overlay) overlay.addEventListener('click', closeCart);

    const closeBtn = document.getElementById('close-cart-btn');
    if (closeBtn) closeBtn.addEventListener('click', closeCart);
}

// Expose to window for HTML access
window.cartModule = {
    addToCart,
    removeFromCart,
    updateQuantity,
    initCart,
    openCart,
    closeCart
};
