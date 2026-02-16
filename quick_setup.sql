-- ============================================
-- Attendance System - Simple Setup SQL
-- ============================================

-- Step 1: Create employees table
DROP TABLE IF EXISTS public.client_reports;
DROP TABLE IF EXISTS public.attendance_records;
DROP TABLE IF EXISTS public.employees;

CREATE TABLE public.employees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'regular',
    role TEXT DEFAULT 'Employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Insert employees
INSERT INTO public.employees (name, type, role) VALUES
('JV', 'owner', 'Business Owner'),
('Louie', 'manager', 'Business Manager'),
('Angelito', 'regular', 'Video Editor'),
('Adrian', 'regular', 'Video Editor'),
('Jeff', 'regular', 'Video Editor'),
('Josh', 'regular', 'Video Editor'),
('John', 'regular', 'Video Editor');

-- Step 3: Create attendance table
CREATE TABLE public.attendance_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    employee_name TEXT NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    check_out_time TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'checked_in',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 4: Create client_reports table
CREATE TABLE public.client_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    attendance_id UUID REFERENCES public.attendance_records(id) ON DELETE CASCADE,
    employee_name TEXT NOT NULL,
    client_name TEXT NOT NULL,
    report TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 5: Enable RLS
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.client_reports ENABLE ROW LEVEL SECURITY;

-- Step 6: Create policies
CREATE POLICY "Allow all operations" ON public.employees FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.attendance_records FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.client_reports FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Step 7: Verify
SELECT 'Employees:' as info;
SELECT * FROM public.employees ORDER BY name;
