-- ============================================
-- Attendance System - Database Schema
-- Supabase SQL Setup Script
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLE 1: Attendance Records
-- ============================================
CREATE TABLE IF NOT EXISTS public.attendance_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'checked_in' CHECK (status IN ('checked_in', 'checked_out')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TABLE 2: Client Reports (for Louie)
-- ============================================
CREATE TABLE IF NOT EXISTS public.client_reports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TABLE 3: Employees (for self-registration)
-- ============================================
CREATE TABLE IF NOT EXISTS public.employees (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'regular' CHECK (type IN ('regular', 'manager', 'owner')),
    role TEXT DEFAULT 'Employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS POLICIES
-- ============================================

-- Attendance Records Policies
DROP POLICY IF EXISTS "Anyone can insert attendance" ON public.attendance_records;
DROP POLICY IF EXISTS "Only authenticated users can view attendance" ON public.attendance_records;
DROP POLICY IF EXISTS "Anyone can update their own attendance" ON public.attendance_records;

CREATE POLICY "Enable insert for authenticated users" ON public.attendance_records
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Enable read for authenticated users" ON public.attendance_records
FOR SELECT TO authenticated USING (true);

CREATE POLICY "Enable update for authenticated users" ON public.attendance_records
FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

-- Client Reports Policies
DROP POLICY IF EXISTS "Anyone can insert client reports" ON public.client_reports;
DROP POLICY IF EXISTS "Only authenticated users can view client reports" ON public.client_reports;

CREATE POLICY "Enable insert for authenticated users" ON public.client_reports
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Enable read for authenticated users" ON public.client_reports
FOR SELECT TO authenticated USING (true);

-- Employees Policies (for registration)
DROP POLICY IF EXISTS "Anyone can register as employee" ON public.employees;
DROP POLICY IF EXISTS "Anyone can view employees" ON public.employees;

CREATE POLICY "Enable insert for authenticated users" ON public.employees
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Enable read for authenticated users" ON public.employees
FOR SELECT TO authenticated USING (true);

-- ============================================
-- INDEXES (for better performance)
-- ============================================

DROP INDEX IF EXISTS idx_attendance_employee;
DROP INDEX IF EXISTS idx_attendance_checkin;
DROP INDEX IF EXISTS idx_attendance_status;
DROP INDEX IF EXISTS idx_client_reports_attendance;
DROP INDEX IF EXISTS idx_client_reports_employee;
DROP INDEX IF EXISTS idx_client_reports_created;
DROP INDEX IF EXISTS idx_employees_name;
DROP INDEX IF EXISTS idx_employees_type;

CREATE INDEX IF NOT EXISTS idx_attendance_employee ON public.attendance_records(employee_name);
CREATE INDEX IF NOT EXISTS idx_attendance_checkin ON public.attendance_records(check_in_time DESC);
CREATE INDEX IF NOT EXISTS idx_attendance_status ON public.attendance_records(status);
CREATE INDEX IF NOT EXISTS idx_client_reports_attendance ON public.client_reports(attendance_id);
CREATE INDEX IF NOT EXISTS idx_client_reports_employee ON public.client_reports(employee_name);
CREATE INDEX IF NOT EXISTS idx_client_reports_created ON public.client_reports(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_employees_name ON public.employees(name);
CREATE INDEX IF NOT EXISTS idx_employees_type ON public.employees(type);

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Get today's attendance summary
CREATE OR REPLACE FUNCTION get_today_attendance()
RETURNS TABLE (
    id UUID,
    employee_name TEXT,
    check_in_time TIMESTAMP WITH TIME ZONE,
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT,
    created_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.attendance_records
    WHERE DATE(check_in_time) = CURRENT_DATE
    ORDER BY check_in_time DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- SAMPLE DATA (for testing)
-- ============================================

-- Insert default employees (run this separately if needed)
-- NOTE: 'owner' type (JV) is hidden from employees but can check in/out
/*
INSERT INTO public.employees (name, type, role) VALUES
('JV', 'owner', 'Business Owner'),
('Louie', 'manager', 'Business Manager'),
('Angelito', 'regular', 'Video Editor'),
('Adrian', 'regular', 'Video Editor'),
('Jeff', 'regular', 'Video Editor'),
('Josh', 'regular', 'Video Editor'),
('John', 'regular', 'Video Editor');

-- Insert a test attendance record
INSERT INTO public.attendance_records (employee_name, check_in_time, status)
VALUES ('JV', NOW() - INTERVAL '8 hours', 'checked_in');
*/

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check if tables were created
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;

-- View all data
-- SELECT * FROM public.employees ORDER BY name;
-- SELECT * FROM public.attendance_records ORDER BY created_at DESC LIMIT 10;
