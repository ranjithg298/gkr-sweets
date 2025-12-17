-- Seed data for GKR Sweets Products
-- Run this in Supabase SQL Editor

INSERT INTO products (name, slug, description, price, category, images, weight, stock, active) VALUES
(
  'Vegan Karupatti Mysorepak',
  'vegan-karupatti-mysorepak',
  'Authentic Vegan Karupatti Mysorepak made with palm jaggery.',
  270.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/files/IMG-20231016-WA0011fb16.jpg?v=1697446035'],
  '250 gms',
  100,
  true
),
(
  'Vegan Mysorepak',
  'vegan-mysorepak',
  'Traditional Vegan Mysorepak.',
  230.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/files/IMG-20231015-WA00022d74.jpg?v=1697442789'],
  '250 gms',
  100,
  true
),
(
  'Vegan Dry Fruits Ladoo',
  'vegan-dry-fruits-ladoo',
  'Healthy and delicious Vegan Dry Fruits Ladoo.',
  290.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/files/Untitleddesign_18_f5d71cbe-b6c7-49cb-9637-8ddb19b0c491d913.png?v=1697521006'],
  '250 gms',
  100,
  true
),
(
  'Thoothukudi macroon',
  'thoothukudi-macroon',
  'Famous Thoothukudi Macaroons.',
  180.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/files/thoothukudi-macaroon8d6a.jpg?v=1749048234'],
  '100 gms',
  100,
  true
),
(
  'Srivilliputhur Palkova',
  'srivilliputhur-palkova',
  'Traditional Srivilliputhur Palkova.',
  190.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/files/Srivilliputhur_Palkovacd2a.png?v=1759679031'],
  '250 gms',
  100,
  true
),
(
  'Thoothukudi Nei Kuchi Mittai',
  'thoothukudi-nei-kuchi-mittai',
  'Nostalgic Thoothukudi Nei Kuchi Mittai.',
  175.00,
  'Sweets',
  ARRAY['https://pettikadai.in/cdn/shop/products/Neikuchimittai0694.jpg?v=1749048255'],
  '100 gms',
  100,
  true
)
ON CONFLICT (slug) DO UPDATE SET
  price = EXCLUDED.price,
  images = EXCLUDED.images,
  weight = EXCLUDED.weight;
