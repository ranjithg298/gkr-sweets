'use client';

import { useState, useEffect } from 'react';
import Image from 'next/image';
import Link from 'next/link';

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

export default function ProductGrid() {
    const [products, setProducts] = useState<Product[]>([]);
    const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [selectedVendor, setSelectedVendor] = useState('All');
    const [selectedCategory, setSelectedCategory] = useState('All');

    useEffect(() => {
        fetch('/products.json')
            .then(res => res.json())
            .then(data => {
                setProducts(data);
                setFilteredProducts(data);
                setLoading(false);
            })
            .catch(err => {
                console.error('Failed to load products', err);
                setLoading(false);
            });
    }, []);

    useEffect(() => {
        let result = products;

        if (search) {
            const lowerSearch = search.toLowerCase();
            result = result.filter(p =>
                p.title.toLowerCase().includes(lowerSearch) ||
                p.vendor.toLowerCase().includes(lowerSearch)
            );
        }

        if (selectedVendor !== 'All') {
            result = result.filter(p => p.vendor === selectedVendor);
        }

        if (selectedCategory !== 'All') {
            result = result.filter(p => p.category === selectedCategory);
        }

        setFilteredProducts(result);
    }, [search, selectedVendor, selectedCategory, products]);

    const vendors = ['All', ...Array.from(new Set(products.map(p => p.vendor)))];
    const categories = ['All', ...Array.from(new Set(products.map(p => p.category)))];

    if (loading) return <div className="p-8 text-center">Loading products...</div>;

    return (
        <div className="container mx-auto p-4">
            <div className="mb-8 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                <input
                    type="text"
                    placeholder="Search products..."
                    className="border p-2 rounded w-full md:w-1/3"
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                />

                <div className="flex gap-4">
                    <select
                        className="border p-2 rounded"
                        value={selectedVendor}
                        onChange={(e) => setSelectedVendor(e.target.value)}
                    >
                        {vendors.map(v => <option key={v} value={v}>{v}</option>)}
                    </select>

                    <select
                        className="border p-2 rounded"
                        value={selectedCategory}
                        onChange={(e) => setSelectedCategory(e.target.value)}
                    >
                        {categories.map(c => <option key={c} value={c}>{c}</option>)}
                    </select>
                </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                {filteredProducts.map(product => (
                    <div key={product.id} className="border rounded-lg overflow-hidden shadow-sm hover:shadow-md transition-shadow bg-white">
                        <div className="relative h-48 w-full bg-gray-100">
                            {product.images[0] ? (
                                <Image
                                    src={product.images[0]}
                                    alt={product.title}
                                    fill
                                    className="object-contain p-2"
                                    sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                                />
                            ) : (
                                <div className="flex items-center justify-center h-full text-gray-400">No Image</div>
                            )}
                        </div>
                        <div className="p-4">
                            <div className="text-xs text-gray-500 mb-1 uppercase tracking-wide">{product.vendor}</div>
                            <h3 className="font-medium text-lg mb-2 line-clamp-2 h-14" title={product.title}>{product.title}</h3>
                            <div className="flex items-center justify-between mt-4">
                                <span className="font-bold text-xl">₹{product.price}</span>
                                <Link
                                    href={`/product/${product.id}`}
                                    className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm transition-colors"
                                >
                                    View
                                </Link>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}
