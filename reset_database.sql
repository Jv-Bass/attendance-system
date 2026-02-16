-- ============================================
-- Fix EOD Reports and Client Reports Tables
-- ============================================

-- Step 1: Drop existing tables and recreate (to ensure they exist)
DROP TABLE IF EXISTS public.client_reports;
DROP TABLE IF EXISTS public.eod_reports;
DROP TABLE IF EXISTS public.attendance_records;
DROP TABLE IF EXISTS public.employees;

-- Step 2: Create employees table
CREATE TABLE public.employees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'regular',
    role TEXT DEFAULT 'Employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Create attendance table
CREATE TABLE public.attendance_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'checked_in',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 4: Create EOD reports table
CREATE TABLE public.eod_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    videos_done TEXT,
    revisions_done TEXT,
    new_videos_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 5: Create client reports table
CREATE TABLE public.client_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 6: Insert employees
INSERT INTO public.employees (name, type, role) VALUES
('JV', 'owner', 'Business Owner'),
('Louie', 'manager', 'Business Manager'),
('Angelito', 'regular', 'Video Editor'),
('Adrian', 'regular', 'Video Editor'),
('Jeff', 'regular', 'Video Editor'),
('Josh', 'regular', 'Video Editor'),
('John', 'regular', 'Video Editor');

-- Step 7: Enable RLS
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eod_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;

-- Step 8: Create policies (allow anon role for public access)
CREATE POLICY "Allow public insert employees" ON public.employees FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read employees" ON public.employees FOR SELECT TO anon USING (true);

CREATE POLICY "Allow public insert attendance" ON public.attendance_records FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read attendance" ON public.attendance_records FOR SELECT TO anon USING (true);
CREATE POLICY "Allow public update attendance" ON public.attendance_records FOR UPDATE TO anon USING (true);

CREATE POLICY "Allow public insert eod" ON public.eod_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read eod" ON public.eod_reports FOR SELECT TO anon USING (true);

CREATE POLICY "Allow public insert client" ON public.client_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read client" ON public.client_reports FOR SELECT TO anon USING (true);

-- Step 9: Add sample data for testing
INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at) VALUES
('Angelito', 'Video 1, Video 2', 'Revision on Client A', 2, NOW()),
('Adrian', 'Video 3', 'None', 1, NOW() - INTERVAL '1 hour'),
('Jeff', 'Video 4, Video 5, Video 6', 'Revision B, Revision C', 3, NOW() - INTERVAL '2 hours'),
('Josh', 'Video 7', 'Revision D', 1, NOW() - INTERVAL '30 minutes'),
('John', 'Video 8, Video 9', 'Revision E, Revision F', 2, NOW() - INTERVAL '1 day');

INSERT INTO public.client_reports (employee_name, client_name, report, created_at) VALUES
('Louie', 'Client A', 'Discussed project timeline and deliverables. Client happy with progress.', NOW()),
('Louie', 'Client B', 'Review meeting. Approved new video concepts.', NOW() - INTERVAL '3 hours'),
('Louie', 'Client C', 'Feedback session. Made notes for revisions.', NOW() - INTERVAL '1 day');

-- Verify
SELECT '=== Tables Created ===' as status;
SELECT 'employees' as table_name, COUNT(*) as count FROM public.employees
UNION ALL
SELECT 'attendance_records', COUNT(*) FROM public.attendance_records
UNION ALL
SELECT 'eod_reports', COUNT(*) FROM public.eod_reports
UNION ALL
SELECT 'client_reports', COUNT(*) FROM public.client_reports;
