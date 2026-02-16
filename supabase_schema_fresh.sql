-- ============================================
-- Attendance System - Database Schema (Fresh Install)
-- Project: https://uwnnpvepyyutrxsnhzku.supabase.co
-- ============================================

-- Step 1: Drop existing tables (if any)
DROP TABLE IF EXISTS public.client_reports CASCADE;
DROP TABLE IF EXISTS public.attendance_records CASCADE;
DROP TABLE IF EXISTS public.employees CASCADE;

-- Step 2: Drop existing policies
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.attendance_records;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.client_reports;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.client_reports;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.employees;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.employees;

-- Step 3: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 4: Create employees table
CREATE TABLE IF NOT EXISTS public.employees (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'regular' CHECK (type IN ('regular', 'manager', 'owner')),
    role TEXT DEFAULT 'Employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 5: Create attendance_records table
CREATE TABLE IF NOT EXISTS public.attendance_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'checked_in' CHECK (status IN ('checked_in', 'checked_out')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 6: Create client_reports table
CREATE TABLE IF NOT EXISTS public.client_reports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 7: Enable RLS on all tables
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;

-- Step 8: Create policies
CREATE POLICY "Enable insert for authenticated users" ON public.employees FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Enable read for authenticated users" ON public.employees FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable insert for authenticated users" ON public.attendance_records FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Enable read for authenticated users" ON public.attendance_records FOR SELECT TO authenticated USING (true);
CREATE POLICY "Enable update for authenticated users" ON public.attendance_records FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Enable insert for authenticated users" ON public.client_reports FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Enable read for authenticated users" ON public.client_reports FOR SELECT TO authenticated USING (true);

-- Step 9: Create indexes
CREATE INDEX IF NOT EXISTS idx_employees_name ON public.employees(name);
CREATE INDEX IF NOT EXISTS idx_employees_type ON public.employees(type);
CREATE INDEX IF NOT EXISTS idx_attendance_employee ON public.attendance_records(employee_name);
CREATE INDEX IF NOT EXISTS idx_attendance_checkin ON public.attendance_records(check_in_time DESC);
CREATE INDEX IF NOT EXISTS idx_client_reports_attendance ON public.client_reports(attendance_id);

-- Step 10: Insert default employees
INSERT INTO public.employees (name, type, role) VALUES
('JV', 'owner', 'Business Owner'),
('Louie', 'manager', 'Business Manager'),
('Angelito', 'regular', 'Video Editor'),
('Adrian', 'regular', 'Video Editor'),
('Jeff', 'regular', 'Video Editor'),
('Josh', 'regular', 'Video Editor'),
('John', 'regular', 'Video Editor')
ON CONFLICT (name) DO NOTHING;

-- Verify
SELECT * FROM public.employees ORDER BY name;
