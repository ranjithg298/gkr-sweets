'use client';

import { useCart } from '../context/CartContext';
import Link from 'next/link';
import Image from 'next/image';

export default function CartPage() {
    const { items, removeFromCart, updateQuantity, cartTotal } = useCart();

    if (items.length === 0) {
        return (
            <div className="container mx-auto p-8 text-center">
                <h1 className="text-2xl font-bold mb-4">Your Cart is Empty</h1>
                <p className="mb-8 text-gray-600">Looks like you haven't added anything yet.</p>
                <Link href="/" className="bg-blue-600 text-white px-6 py-3 rounded hover:bg-blue-700">
                    Continue Shopping
                </Link>
            </div>
        );
    }

    return (
        <div className="container mx-auto p-4">
            <h1 className="text-2xl font-bold mb-8">Shopping Cart</h1>

            <div className="flex flex-col lg:flex-row gap-8">
                {/* Cart Items */}
                <div className="flex-1 space-y-4">
                    {items.map(item => (
                        <div key={item.id} className="flex gap-4 border p-4 rounded-lg bg-white shadow-sm">
                            <div className="relative h-24 w-24 flex-shrink-0 bg-gray-100 rounded overflow-hidden">
                                <Image src={item.image} alt={item.title} fill className="object-contain" />
                            </div>

                            <div className="flex-1">
                                <div className="flex justify-between mb-2">
                                    <h3 className="font-medium">{item.title}</h3>
                                    <button
                                        onClick={() => removeFromCart(item.id)}
                                        className="text-red-500 hover:text-red-700 text-sm"
                                    >
                                        Remove
                                    </button>
                                </div>
                                <p className="text-sm text-gray-500 mb-2">{item.vendor}</p>
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center border rounded">
                                        <button
                                            className="px-3 py-1 hover:bg-gray-100"
                                            onClick={() => updateQuantity(item.id, item.quantity - 1)}
                                        >
                                            -
                                        </button>
                                        <span className="px-3 py-1 border-x">{item.quantity}</span>
                                        <button
                                            className="px-3 py-1 hover:bg-gray-100"
                                            onClick={() => updateQuantity(item.id, item.quantity + 1)}
                                        >
                                            +
                                        </button>
                                    </div>
                                    <div className="font-bold">₹{item.price * item.quantity}</div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>

                {/* Order Summary */}
                <div className="w-full lg:w-80 h-fit bg-white p-6 rounded-lg shadow-sm border">
                    <h2 className="text-lg font-bold mb-4">Order Summary</h2>
                    <div className="flex justify-between mb-2">
                        <span>Subtotal</span>
                        <span>₹{cartTotal}</span>
                    </div>
                    <div className="flex justify-between mb-4">
                        <span>Shipping</span>
                        <span className="text-green-600">Free</span>
                    </div>
                    <div className="border-t pt-4 mb-6 flex justify-between font-bold text-lg">
                        <span>Total</span>
                        <span>₹{cartTotal}</span>
                    </div>
                    <Link
                        href="/checkout"
                        className="block w-full bg-blue-600 text-white text-center py-3 rounded hover:bg-blue-700 font-bold"
                    >
                        Proceed to Checkout
                    </Link>
                </div>
            </div>
        </div>
    );
}
