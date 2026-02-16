-- ============================================
-- Fix Client Reports Table Only (Safe - won't delete data)
-- ============================================

-- Step 1: Create client_reports table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.client_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Enable RLS
ALTER TABLE IF EXISTS public.client_reports ENABLE ROW LEVEL SECURITY;

-- Step 3: Drop old policies and create new ones
DROP POLICY IF EXISTS "Allow public insert client" ON public.client_reports;
DROP POLICY IF EXISTS "Allow public read client" ON public.client_reports;

CREATE POLICY "Allow public insert client" ON public.client_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read client" ON public.client_reports FOR SELECT TO anon USING (true);

-- Step 4: Add sample client reports (only if table is empty)
INSERT INTO public.client_reports (employee_name, client_name, report, created_at)
SELECT 'Louie', 'Client A', 'Discussed project timeline and deliverables. Client happy with progress.', NOW()
WHERE NOT EXISTS (SELECT 1 FROM public.client_reports WHERE employee_name = 'Louie' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.client_reports (employee_name, client_name, report, created_at)
SELECT 'Louie', 'Client B', 'Review meeting. Approved new video concepts.', NOW() - INTERVAL '3 hours'
WHERE NOT EXISTS (SELECT 1 FROM public.client_reports WHERE employee_name = 'Louie' AND created_at > NOW() - INTERVAL '1 day');

INSERT INTO public.client_reports (employee_name, client_name, report, created_at)
SELECT 'Louie', 'Client C', 'Feedback session. Made notes for revisions.', NOW() - INTERVAL '1 day'
WHERE NOT EXISTS (SELECT 1 FROM public.client_reports WHERE employee_name = 'Louie' AND created_at > NOW() - INTERVAL '2 days');

-- Verify
SELECT '=== Client Reports Table Status ===' as info;
SELECT COUNT(*) as total_client_reports FROM public.client_reports;
SELECT * FROM public.client_reports ORDER BY created_at DESC LIMIT 5;
