import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'enchipsu.com',
      },
      {
        protocol: 'https',
        hostname: 'pettikadai.in',
      },
      {
        protocol: 'https',
        hostname: 'www.oorla.in',
      },
      {
        protocol: 'https',
        hostname: 'purelysouth.com',
      },
      {
        protocol: 'https',
        hostname: 'cdn.shopify.com',
      },
      {
        protocol: 'https',
        hostname: 'placehold.co',
      },
    ],
  },
};

export default nextConfig;
