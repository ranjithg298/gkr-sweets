// Supabase Configuration for GKR Sweets
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

const supabaseUrl = 'https://mamsjkoxduulgveshdcf.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hbXNqa294ZHV1bGd2ZXNoZGNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MjY3NzEsImV4cCI6MjA3OTQwMjc3MX0.rk2qTSXHJbdR23Buesz7kEV0CCk9IJP961Ym2TyWFEo';


// Initialize Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Auth helper functions
export const auth = {
    // Sign up with email and password
    signUp: async (email, password, metadata = {}) => {
        const { data, error } = await supabase.auth.signUp({
            email,
            password,
            options: {
                data: metadata
            }
        });
        return { data, error };
    },

    // Sign in with email and password
    signIn: async (email, password) => {
        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password
        });
        return { data, error };
    },

    // Sign in with Google
    signInWithGoogle: async () => {
        const { data, error } = await supabase.auth.signInWithOAuth({
            provider: 'google',
            options: {
                redirectTo: window.location.origin + '/pettikadai.in/indexab3f.html'
            }
        });
        return { data, error };
    },

    // Sign out
    signOut: async () => {
        const { error } = await supabase.auth.signOut();
        return { error };
    },

    // Get current user
    getCurrentUser: async () => {
        const { data: { user } } = await supabase.auth.getUser();
        return user;
    },

    // Listen to auth state changes
    onAuthStateChange: (callback) => {
        return supabase.auth.onAuthStateChange((event, session) => {
            callback(session?.user || null);
        });
    }
};

// Storage helper functions
export const storage = {
    // Upload file
    upload: async (bucket, path, file) => {
        const { data, error } = await supabase.storage
            .from(bucket)
            .upload(path, file);
        return { data, error };
    },

    // Get public URL
    getPublicUrl: (bucket, path) => {
        const { data } = supabase.storage
            .from(bucket)
            .getPublicUrl(path);
        return data.publicUrl;
    },

    // Delete file
    delete: async (bucket, paths) => {
        const { data, error } = await supabase.storage
            .from(bucket)
            .remove(paths);
        return { data, error };
    }
};

// Database helper functions
export const db = {
    // Insert data
    insert: async (table, data) => {
        const { data: result, error } = await supabase
            .from(table)
            .insert(data)
            .select();
        return { data: result, error };
    },

    // Select data
    select: async (table, columns = '*', filters = {}) => {
        let query = supabase.from(table).select(columns);

        // Apply filters
        Object.entries(filters).forEach(([key, value]) => {
            query = query.eq(key, value);
        });

        const { data, error } = await query;
        return { data, error };
    },

    // Update data
    update: async (table, id, data) => {
        const { data: result, error } = await supabase
            .from(table)
            .update(data)
            .eq('id', id)
            .select();
        return { data: result, error };
    },

    // Delete data
    delete: async (table, id) => {
        const { data, error } = await supabase
            .from(table)
            .delete()
            .eq('id', id);
        return { data, error };
    }
};

// Categories helper functions
export const categories = {
    // Get all categories
    getAll: async () => {
        const { data, error } = await supabase
            .from('categories')
            .select('*');
        return { data, error };
    }
};

// Products helper functions
export const products = {
    // Get all products
    getAll: async () => {
        const { data, error } = await supabase
            .from('products')
            .select('*')
            .eq('active', true);
        return { data, error };
    },

    // Get product by ID
    getById: async (id) => {
        const { data, error } = await supabase
            .from('products')
            .select('*')
            .eq('id', id)
            .single();
        return { data, error };
    },

    // Get product by Slug
    getBySlug: async (slug) => {
        const { data, error } = await supabase
            .from('products')
            .select('*')
            .eq('slug', slug)
            .single();
        return { data, error };
    },

    // Get products by category
    getByCategory: async (category) => {
        const { data, error } = await supabase
            .from('products')
            .select('*')
            .eq('category', category)
            .eq('active', true);
        return { data, error };
    }
};

// Cart helper functions
export const cart = {
    // Get cart items
    getCart: async (sessionId) => {
        const { data, error } = await supabase
            .from('cart_items')
            .select(`
                *,
                products (*)
            `)
            .eq('session_id', sessionId);
        return { data, error };
    },

    // Add item to cart
    addItem: async (sessionId, productId, quantity) => {
        const { data, error } = await supabase
            .from('cart_items')
            .upsert({
                session_id: sessionId,
                product_id: productId,
                quantity: quantity
            }, { onConflict: 'session_id, product_id' })
            .select();
        return { data, error };
    },

    // Remove item from cart
    removeItem: async (id) => {
        const { error } = await supabase
            .from('cart_items')
            .delete()
            .eq('id', id);
        return { error };
    },

    // Update quantity
    updateQuantity: async (id, quantity) => {
        const { data, error } = await supabase
            .from('cart_items')
            .update({ quantity })
            .eq('id', id)
            .select();
        return { data, error };
    }
};

export default supabase;
