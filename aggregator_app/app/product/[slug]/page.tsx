'use client';

import { useState, useEffect } from 'react';
import Image from 'next/image';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import { useCart } from '../../context/CartContext';

interface Product {
    id: string;
    title: string;
    handle: string;
    vendor: string;
    price: number;
    images: string[];
    url: string;
    description: string;
    category: string;
}

export default function ProductPage() {
    const params = useParams();
    const router = useRouter();
    const slug = params.slug as string;
    const [product, setProduct] = useState<Product | null>(null);
    const [loading, setLoading] = useState(true);
    const { addToCart } = useCart();

    useEffect(() => {
        fetch('/products.json')
            .then(res => res.json())
            .then((data: Product[]) => {
                const found = data.find(p => p.id === slug);
                setProduct(found || null);
                setLoading(false);
            })
            .catch(err => {
                console.error(err);
                setLoading(false);
            });
    }, [slug]);

    if (loading) return <div className="p-8 text-center">Loading...</div>;
    if (!product) return <div className="p-8 text-center">Product not found</div>;

    return (
        <div className="container mx-auto p-4">
            <Link href="/" className="text-blue-600 hover:underline mb-4 inline-block">&larr; Back to Products</Link>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 bg-white p-6 rounded-lg shadow-sm">
                <div className="space-y-4">
                    <div className="relative h-96 w-full bg-gray-100 rounded-lg overflow-hidden border">
                        {product.images[0] ? (
                            <Image src={product.images[0]} alt={product.title} fill className="object-contain" />
                        ) : (
                            <div className="flex items-center justify-center h-full text-gray-400">No Image</div>
                        )}
                    </div>
                    <div className="flex gap-2 overflow-x-auto pb-2">
                        {product.images.map((img, i) => (
                            <div key={i} className="relative h-20 w-20 flex-shrink-0 border rounded cursor-pointer hover:border-blue-500">
                                <Image src={img} alt={`${product.title} ${i}`} fill className="object-cover" />
                            </div>
                        ))}
                    </div>
                </div>

                <div>
                    <div className="text-sm text-gray-500 uppercase tracking-wide mb-2">{product.vendor}</div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-4">{product.title}</h1>
                    <div className="text-2xl font-bold text-gray-900 mb-6">₹{product.price}</div>

                    <div className="prose max-w-none text-gray-700 mb-8" dangerouslySetInnerHTML={{ __html: product.description }} />

                    <div className="flex gap-4">
                        <button
                            className="flex-1 bg-yellow-400 hover:bg-yellow-500 text-black font-bold py-3 px-6 rounded-lg transition-colors shadow-sm"
                            onClick={() => {
                                addToCart(product);
                                alert('Added to cart!');
                            }}
                        >
                            Add to Cart
                        </button>
                        <button
                            className="flex-1 bg-orange-600 hover:bg-orange-700 text-white font-bold py-3 px-6 rounded-lg transition-colors shadow-sm"
                            onClick={() => {
                                addToCart(product);
                                router.push('/checkout');
                            }}
                        >
                            Buy Now
                        </button>
                    </div>

                    <div className="mt-6 text-sm text-gray-500">
                        <p>Category: {product.category}</p>
                        <p>Vendor: {product.vendor}</p>
                    </div>
                </div>
            </div>
        </div>
    );
}
