-- ============================================
-- Fix EOD Reports Table Only (Safe - won't delete data)
-- ============================================

-- Step 1: Create eod_reports table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.eod_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    videos_done TEXT,
    revisions_done TEXT,
    new_videos_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Enable RLS
ALTER TABLE IF EXISTS public.eod_reports ENABLE ROW LEVEL SECURITY;

-- Step 3: Drop old policies and create new ones
DROP POLICY IF EXISTS "Allow public insert eod" ON public.eod_reports;
DROP POLICY IF EXISTS "Allow public read eod" ON public.eod_reports;

CREATE POLICY "Allow public insert eod" ON public.eod_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read eod" ON public.eod_reports FOR SELECT TO anon USING (true);

-- Step 4: Add sample EOD reports (only if table is empty)
INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 'Angelito', 'Video 1, Video 2', 'Revision on Client A', 2, NOW()
WHERE NOT EXISTS (SELECT 1 FROM public.eod_reports WHERE employee_name = 'Angelito' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 'Adrian', 'Video 3', 'None', 1, NOW() - INTERVAL '1 hour'
WHERE NOT EXISTS (SELECT 1 FROM public.eod_reports WHERE employee_name = 'Adrian' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 'Jeff', 'Video 4, Video 5, Video 6', 'Revision B, Revision C', 3, NOW() - INTERVAL '2 hours'
WHERE NOT EXISTS (SELECT 1 FROM public.eod_reports WHERE employee_name = 'Jeff' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 'Josh', 'Video 7', 'Revision D', 1, NOW() - INTERVAL '30 minutes'
WHERE NOT EXISTS (SELECT 1 FROM public.eod_reports WHERE employee_name = 'Josh' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 'John', 'Video 8, Video 9', 'Revision E, Revision F', 2, NOW() - INTERVAL '1 day'
WHERE NOT EXISTS (SELECT 1 FROM public.eod_reports WHERE employee_name = 'John' AND created_at > NOW() - INTERVAL '2 days');

-- Verify
SELECT '=== EOD Reports Table Status ===' as info;
SELECT COUNT(*) as total_eod_reports FROM public.eod_reports;
SELECT * FROM public.eod_reports ORDER BY created_at DESC LIMIT 5;
