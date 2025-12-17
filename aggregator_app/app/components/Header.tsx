'use client';

import Link from 'next/link';
import { useCart } from '../context/CartContext';

export default function Header() {
    const { cartCount } = useCart();

    return (
        <header className="bg-white shadow-sm sticky top-0 z-50">
            <div className="container mx-auto px-4 py-4 flex items-center justify-between">
                <Link href="/" className="text-2xl font-bold text-blue-600">
                    GKR Marketplace
                </Link>

                <nav className="flex items-center gap-6">
                    <Link href="/" className="text-gray-600 hover:text-blue-600">
                        Home
                    </Link>
                    <Link href="/cart" className="relative text-gray-600 hover:text-blue-600">
                        <span className="text-xl">🛒</span>
                        {cartCount > 0 && (
                            <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center">
                                {cartCount}
                            </span>
                        )}
                    </Link>
                    <Link href="/auth" className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                        Login
                    </Link>
                </nav>
            </div>
        </header>
    );
}
