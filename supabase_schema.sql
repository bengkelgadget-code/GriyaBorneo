-- ==============================================================================
-- SCHEMA LENGKAP GRIYA BORNEO PROPERTY CMS & LIVE CHAT CRM
-- Project Supabase Baru: sqnpjposcfvoinwzxsjo
-- ==============================================================================

-- 0. Ekstensi UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================================================
-- 1. TABEL PROPERTIES (Katalog Properti)
-- ==============================================================================
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

-- Index untuk performa query
CREATE INDEX IF NOT EXISTS idx_properties_published ON public.properties (is_published);
CREATE INDEX IF NOT EXISTS idx_properties_slug ON public.properties (slug);
CREATE INDEX IF NOT EXISTS idx_properties_featured ON public.properties (is_featured);

-- RLS Properties
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view published properties" ON public.properties;
CREATE POLICY "Public can view published properties" 
ON public.properties FOR SELECT 
USING (is_published = true OR auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Admins can insert properties" ON public.properties;
CREATE POLICY "Admins can insert properties" 
ON public.properties FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Admins can update properties" ON public.properties;
CREATE POLICY "Admins can update properties" 
ON public.properties FOR UPDATE 
USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Admins can delete properties" ON public.properties;
CREATE POLICY "Admins can delete properties" 
ON public.properties FOR DELETE 
USING (auth.role() = 'authenticated');


-- ==============================================================================
-- 2. TABEL SETTINGS & APP_SETTINGS (Pengaturan Website & WhatsApp CTA)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.app_settings (
    id TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.settings (
    id TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Default WhatsApp number
INSERT INTO public.app_settings (id, value, description)
VALUES ('whatsapp_number', '6281234567890', 'Nomor WhatsApp utama untuk kontak CTA')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.settings (id, value, description)
VALUES ('whatsapp_number', '6281234567890', 'Nomor WhatsApp utama untuk kontak CTA')
ON CONFLICT (id) DO NOTHING;

-- RLS Settings & App_Settings
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "app_settings viewable by everyone" ON public.app_settings;
CREATE POLICY "app_settings viewable by everyone" 
ON public.app_settings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Admins can manage app_settings" ON public.app_settings;
CREATE POLICY "Admins can manage app_settings" 
ON public.app_settings FOR ALL 
USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "settings viewable by everyone" ON public.settings;
CREATE POLICY "settings viewable by everyone" 
ON public.settings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Admins can manage settings" ON public.settings;
CREATE POLICY "Admins can manage settings" 
ON public.settings FOR ALL 
USING (auth.role() = 'authenticated');


-- ==============================================================================
-- 3. TABEL CUSTOMER_LEADS & N8N_CHAT_HISTORIES (Live Chat CRM)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.customer_leads (
    phone_number TEXT PRIMARY KEY,
    customer_name TEXT,
    unit_interest TEXT,
    survey_schedule TEXT,
    survey_status TEXT DEFAULT 'no_survey',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.n8n_chat_histories (
    id BIGSERIAL PRIMARY KEY,
    session_id TEXT NOT NULL,
    message JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_n8n_chat_session ON public.n8n_chat_histories (session_id);

-- RLS Chat & Leads
ALTER TABLE public.customer_leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.n8n_chat_histories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all access to customer_leads" ON public.customer_leads;
CREATE POLICY "Allow all access to customer_leads" 
ON public.customer_leads FOR ALL 
USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all access to n8n_chat_histories" ON public.n8n_chat_histories;
CREATE POLICY "Allow all access to n8n_chat_histories" 
ON public.n8n_chat_histories FOR ALL 
USING (true) WITH CHECK (true);


-- ==============================================================================
-- 4. REALTIME PUBLICATION (Untuk Notifikasi Live Chat Instan)
-- ==============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.customer_leads;
ALTER PUBLICATION supabase_realtime ADD TABLE public.n8n_chat_histories;


-- ==============================================================================
-- 5. STORAGE BUCKET (Penyimpanan Foto Properti)
-- ==============================================================================
INSERT INTO storage.buckets (id, name, public) 
VALUES ('property-images', 'property-images', true)
ON CONFLICT (id) DO NOTHING;

-- RLS Storage Objects
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'property-images');

DROP POLICY IF EXISTS "Authenticated users can upload" ON storage.objects;
CREATE POLICY "Authenticated users can upload" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'property-images' AND auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Authenticated users can update" ON storage.objects;
CREATE POLICY "Authenticated users can update" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'property-images' AND auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Authenticated users can delete" ON storage.objects;
CREATE POLICY "Authenticated users can delete" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'property-images' AND auth.role() = 'authenticated');
