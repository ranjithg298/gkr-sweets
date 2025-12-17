// Vercel Serverless Function for Product Seeding
// POST /api/seed-products

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL || 'https://mamsjkoxduulgveshdcf.supabase.co';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hbXNqa294ZHV1bGd2ZXNoZGNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MjY3NzEsImV4cCI6MjA3OTQwMjc3MX0.rk2qTSXHJbdR23Buesz7kEV0CCk9IJP961Ym2TyWFEo';

// Import products data
import productsData from '../products-cleaned.json';

const BATCH_SIZE = 50;
const RETRY_ATTEMPTS = 3;
const RETRY_DELAY = 1000; // 1 second

// Helper function to sleep
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Helper function to retry with exponential backoff
async function retryWithBackoff(fn, attempts = RETRY_ATTEMPTS) {
    for (let i = 0; i < attempts; i++) {
        try {
            return await fn();
        } catch (error) {
            if (i === attempts - 1) throw error;
            const delay = RETRY_DELAY * Math.pow(2, i);
            console.log(`Retry attempt ${i + 1} after ${delay}ms...`);
            await sleep(delay);
        }
    }
}

// Transform product data for Supabase
function transformProduct(product) {
    return {
        name: product.name,
        slug: product.slug,
        description: product.description || '',
        price: parseFloat(product.price),
        category: product.category,
        images: product.images || [],
        weight: product.weight || '1 kg',
        stock: product.stock || 100,
        active: product.active !== false,
        tags: product.tags || [],
        featured: product.featured || false
    };
}

export default async function handler(req, res) {
    // Only allow POST requests
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    const startTime = Date.now();
    const results = {
        total: productsData.length,
        successful: 0,
        failed: 0,
        errors: [],
        batches: []
    };

    try {
        // Initialize Supabase client
        const supabase = createClient(supabaseUrl, supabaseKey);

        console.log(`Starting seeding process for ${productsData.length} products...`);

        // Process products in batches
        for (let i = 0; i < productsData.length; i += BATCH_SIZE) {
            const batch = productsData.slice(i, i + BATCH_SIZE);
            const batchNumber = Math.floor(i / BATCH_SIZE) + 1;
            const totalBatches = Math.ceil(productsData.length / BATCH_SIZE);

            console.log(`Processing batch ${batchNumber}/${totalBatches} (${batch.length} products)...`);

            const transformedBatch = batch.map(transformProduct);

            try {
                // Use upsert to handle duplicates
                const { data, error } = await retryWithBackoff(async () => {
                    return await supabase
                        .from('products')
                        .upsert(transformedBatch, {
                            onConflict: 'slug',
                            ignoreDuplicates: false
                        })
                        .select();
                });

                if (error) {
                    console.error(`Batch ${batchNumber} error:`, error);
                    results.failed += batch.length;
                    results.errors.push({
                        batch: batchNumber,
                        error: error.message,
                        products: batch.map(p => p.slug)
                    });
                } else {
                    results.successful += data?.length || batch.length;
                    results.batches.push({
                        batch: batchNumber,
                        count: data?.length || batch.length,
                        status: 'success'
                    });
                    console.log(`Batch ${batchNumber} completed: ${data?.length || batch.length} products`);
                }
            } catch (error) {
                console.error(`Batch ${batchNumber} failed after retries:`, error);
                results.failed += batch.length;
                results.errors.push({
                    batch: batchNumber,
                    error: error.message,
                    products: batch.map(p => p.slug)
                });
            }

            // Small delay between batches to avoid rate limiting
            if (i + BATCH_SIZE < productsData.length) {
                await sleep(500);
            }
        }

        const duration = ((Date.now() - startTime) / 1000).toFixed(2);

        // Verify final count
        const { count, error: countError } = await supabase
            .from('products')
            .select('*', { count: 'exact', head: true });

        const response = {
            success: results.failed === 0,
            message: results.failed === 0
                ? `Successfully seeded ${results.successful} products in ${duration}s`
                : `Seeding completed with errors. ${results.successful} succeeded, ${results.failed} failed in ${duration}s`,
            results: {
                ...results,
                duration: `${duration}s`,
                totalInDatabase: count || 'unknown'
            }
        };

        console.log('Seeding complete:', response);

        return res.status(results.failed === 0 ? 200 : 207).json(response);

    } catch (error) {
        console.error('Fatal error during seeding:', error);
        return res.status(500).json({
            success: false,
            error: 'Fatal error during seeding',
            message: error.message,
            results
        });
    }
}
