-- ============================================
-- Attendance System - FIXED Security Policies
-- ============================================

-- Step 1: Fix RLS policies for employees table (allow public registration)
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

-- Drop old policies first
DROP POLICY IF EXISTS "Allow all operations" ON public.employees;
DROP POLICY IF EXISTS "Allow insert for all" ON public.employees;
DROP POLICY IF EXISTS "Allow read for all" ON public.employees;

-- Create new policies that allow anyone to INSERT and SELECT
CREATE POLICY "Allow public insert" ON public.employees FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read" ON public.employees FOR SELECT TO anon USING (true);

-- Step 2: Fix RLS policies for attendance_records
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all operations" ON public.attendance_records;
DROP POLICY IF EXISTS "Allow insert for all" ON public.attendance_records;
DROP POLICY IF EXISTS "Allow read for all" ON public.attendance_records;
DROP POLICY IF EXISTS "Allow update for all" ON public.attendance_records;

CREATE POLICY "Allow public insert" ON public.attendance_records FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read" ON public.attendance_records FOR SELECT TO anon USING (true);
CREATE POLICY "Allow public update" ON public.attendance_records FOR UPDATE TO anon USING (true);

-- Step 3: Fix RLS policies for client_reports
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all operations" ON public.client_reports;
DROP POLICY IF EXISTS "Allow insert for all" ON public.client_reports;
DROP POLICY IF EXISTS "Allow read for all" ON public.client_reports;

CREATE POLICY "Allow public insert" ON public.client_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read" ON public.client_reports FOR SELECT TO anon USING (true);

-- Step 4: Also create eod_reports table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.eod_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    videos_done TEXT,
    revisions_done TEXT,
    new_videos_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.eod_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all operations" ON public.eod_reports;
DROP POLICY IF EXISTS "Allow insert for all" ON public.eod_reports;
DROP POLICY IF EXISTS "Allow read for all" ON public.eod_reports;

CREATE POLICY "Allow public insert" ON public.eod_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read" ON public.eod_reports FOR SELECT TO anon USING (true);

-- Verify
SELECT 'Policies updated!' as status;
