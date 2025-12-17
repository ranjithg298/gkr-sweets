import ProductGrid from './components/ProductGrid';

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <header className="bg-white shadow-sm mb-8">
        <div className="container mx-auto p-4">
          <h1 className="text-3xl font-bold text-gray-800">Product Aggregator</h1>
          <p className="text-gray-600">Aggregating products from Enchipsu, Oorla, Purely South, and GKR Sweet</p>
        </div>
      </header>
      <ProductGrid />
    </main>
  );
}
