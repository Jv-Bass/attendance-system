-- ============================================
-- COMPLETE DATABASE FIX SCRIPT
-- Run this in Supabase SQL Editor
-- ============================================

-- Step 1: Drop existing RLS policies (clean slate)
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.eod_reports;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.eod_reports;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.client_reports;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.client_reports;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.employees;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.employees;

-- Step 2: Recreate RLS policies (authenticated users only)
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eod_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

-- Attendance Records Policies
CREATE POLICY "Anyone authenticated can insert" ON public.attendance_records
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anyone authenticated can read" ON public.attendance_records
FOR SELECT TO authenticated USING (true);

CREATE POLICY "Anyone authenticated can update" ON public.attendance_records
FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

-- EOD Reports Policies
CREATE POLICY "Anyone authenticated can insert eod" ON public.eod_reports
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anyone authenticated can read eod" ON public.eod_reports
FOR SELECT TO authenticated USING (true);

-- Client Reports Policies
CREATE POLICY "Anyone authenticated can insert client" ON public.client_reports
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anyone authenticated can read client" ON public.client_reports
FOR SELECT TO authenticated USING (true);

-- Employees Policies
CREATE POLICY "Anyone authenticated can insert employee" ON public.employees
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anyone authenticated can read employee" ON public.employees
FOR SELECT TO authenticated USING (true);

-- Step 3: Verify table structure
SELECT 'attendance_records columns:' as info;
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'attendance_records' 
ORDER BY ordinal_position;

SELECT 'eod_reports columns:' as info;
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'eod_reports' 
ORDER BY ordinal_position;

SELECT 'client_reports columns:' as info;
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'client_reports' 
ORDER BY ordinal_position;

-- Step 4: Test insert (will fail if RLS is wrong)
-- SELECT 'Testing insert...' as test;
-- INSERT INTO public.attendance_records (employee_name, check_in_time, status)
-- VALUES ('Test User', NOW(), 'checked_in')
-- RETURNING id;
