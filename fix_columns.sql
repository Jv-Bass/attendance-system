-- Fix column names in eod_reports table
-- The table was created with 'name' but code expects 'employee_name'

-- Add employee_name column if it doesn't exist
ALTER TABLE public.eod_reports ADD COLUMN IF NOT EXISTS employee_name TEXT;

-- Copy data from 'name' column to 'employee_name' column
UPDATE public.eod_reports 
SET employee_name = name 
WHERE employee_name IS NULL AND name IS NOT NULL;

-- Drop the old 'name' column
ALTER TABLE public.eod_reports DROP COLUMN IF EXISTS name;

-- Rename employee_name to ensure it's correct
ALTER TABLE public.eod_reports RENAME COLUMN employee_name TO employee_name;

-- Add created_at if missing (for date filtering)
ALTER TABLE public.eod_reports ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Verify the table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'eod_reports' 
ORDER BY ordinal_position;
