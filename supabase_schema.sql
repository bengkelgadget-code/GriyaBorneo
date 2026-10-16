-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tabel Properties
CREATE TABLE IF NOT EXISTS public.properties (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    property_type TEXT NOT NULL,
    status TEXT DEFAULT 'available',
    price BIGINT NOT NULL,
    discount_price BIGINT,
    bedrooms INT DEFAULT 0,
    bathrooms INT DEFAULT 0,
    land_area INT DEFAULT 0,
    building_area INT DEFAULT 0,
    floors INT DEFAULT 1,
    certificate TEXT,
    address TEXT,
    city TEXT,
    maps_url TEXT,
    images TEXT[] DEFAULT '{}',
    facilities TEXT[] DEFAULT '{}',
    whatsapp_number TEXT,
    is_featured BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabel Settings (untuk WhatsApp Number dll)
CREATE TABLE IF NOT EXISTS public.settings (
    id TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default WhatsApp setting
INSERT INTO public.settings (id, value, description)
VALUES ('whatsapp_number', '6281234567890', 'Nomor WhatsApp utama untuk kontak CTA')
ON CONFLICT (id) DO NOTHING;

-- 3. Storage Bucket for property images
-- (You need to run this in Supabase SQL editor to create the bucket)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('property-images', 'property-images', true)
ON CONFLICT (id) DO NOTHING;

-- 4. RLS (Row Level Security) Policies

-- Properties: Anyone can read published properties
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone." 
ON public.properties FOR SELECT 
USING (is_published = true);

-- Properties: Authenticated admins can do all CRUD operations
CREATE POLICY "Admins can insert properties" 
ON public.properties FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admins can update properties" 
ON public.properties FOR UPDATE 
USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can delete properties" 
ON public.properties FOR DELETE 
USING (auth.role() = 'authenticated');

-- Settings: Anyone can read settings (for WA button on public page)
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Settings viewable by everyone" 
ON public.settings FOR SELECT 
USING (true);

-- Settings: Only admins can update settings
CREATE POLICY "Admins can update settings" 
ON public.settings FOR UPDATE 
USING (auth.role() = 'authenticated');

-- Storage Policies for 'property-images' bucket
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'property-images');

CREATE POLICY "Authenticated users can upload" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'property-images' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'property-images' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'property-images' AND auth.role() = 'authenticated');
