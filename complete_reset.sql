-- ============================================
-- COMPLETE DATABASE RESET - Attendance System
-- Run this in Supabase SQL Editor
-- ============================================

-- Drop all existing tables (CASCADE to handle dependencies)
DROP TABLE IF EXISTS public.client_reports CASCADE;
DROP TABLE IF EXISTS public.eod_reports CASCADE;
DROP TABLE IF EXISTS public.attendance_records CASCADE;
DROP TABLE IF EXISTS public.employees CASCADE;

-- ============================================
-- Create employees table
-- ============================================
CREATE TABLE public.employees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'regular',
    role TEXT DEFAULT 'Employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Create attendance records table
-- ============================================
CREATE TABLE public.attendance_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'checked_in',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Create EOD reports table
-- ============================================
CREATE TABLE public.eod_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    videos_done TEXT,
    revisions_done TEXT,
    new_videos_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Create client reports table
-- ============================================
CREATE TABLE public.client_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Insert all employees
-- ============================================
INSERT INTO public.employees (name, type, role) VALUES
('JV', 'owner', 'Business Owner'),
('Louie', 'manager', 'Business Manager'),
('Angelito', 'regular', 'Video Editor'),
('Adrian', 'regular', 'Video Editor'),
('Jeff', 'regular', 'Video Editor'),
('Josh', 'regular', 'Video Editor'),
('John', 'regular', 'Video Editor');

-- ============================================
-- Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eod_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;

-- ============================================
-- Create RLS Policies (allow public access)
-- ============================================

-- Employees table
DROP POLICY IF EXISTS "Allow public insert employees" ON public.employees;
DROP POLICY IF EXISTS "Allow public read employees" ON public.employees;
CREATE POLICY "Allow public insert employees" ON public.employees FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read employees" ON public.employees FOR SELECT TO anon USING (true);

-- Attendance records table
DROP POLICY IF EXISTS "Allow public insert attendance" ON public.attendance_records;
DROP POLICY IF EXISTS "Allow public read attendance" ON public.attendance_records;
DROP POLICY IF EXISTS "Allow public update attendance" ON public.attendance_records;
CREATE POLICY "Allow public insert attendance" ON public.attendance_records FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read attendance" ON public.attendance_records FOR SELECT TO anon USING (true);
CREATE POLICY "Allow public update attendance" ON public.attendance_records FOR UPDATE TO anon USING (true);

-- EOD reports table
DROP POLICY IF EXISTS "Allow public insert eod" ON public.eod_reports;
DROP POLICY IF EXISTS "Allow public read eod" ON public.eod_reports;
CREATE POLICY "Allow public insert eod" ON public.eod_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read eod" ON public.eod_reports FOR SELECT TO anon USING (true);

-- Client reports table
DROP POLICY IF EXISTS "Allow public insert client" ON public.client_reports;
DROP POLICY IF EXISTS "Allow public read client" ON public.client_reports;
CREATE POLICY "Allow public insert client" ON public.client_reports FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public read client" ON public.client_reports FOR SELECT TO anon USING (true);

-- ============================================
-- Verify setup
-- ============================================
SELECT '=== DATABASE SETUP COMPLETE ===' as status;

SELECT 'Employees:' as table_name, COUNT(*) as count FROM public.employees
UNION ALL
SELECT 'attendance_records', COUNT(*) FROM public.attendance_records
UNION ALL
SELECT 'eod_reports', COUNT(*) FROM public.eod_reports
UNION ALL
SELECT 'client_reports', COUNT(*) FROM public.client_reports;

SELECT '=== ALL EMPLOYEES ===' as info;
SELECT * FROM public.employees ORDER BY name;
