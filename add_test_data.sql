-- ============================================
-- Add sample data for testing EOD and Client Reports
-- ============================================

-- Check existing data
SELECT '=== Current Data ===' as info;

-- Check attendance records
SELECT COUNT(*) as attendance_count FROM public.attendance_records;

-- Check EOD reports  
SELECT COUNT(*) as eod_reports_count FROM public.eod_reports;

-- Check client reports
SELECT COUNT(*) as client_reports_count FROM public.client_reports;

-- If no EOD reports exist, add sample data
INSERT INTO public.eod_reports (employee_name, videos_done, revisions_done, new_videos_count, created_at)
SELECT 
    name,
    'Sample video 1, Sample video 2',
    'Revision on Project A',
    2,
    NOW() - (random() * interval '7 days')
FROM public.employees
WHERE type = 'regular'
ON CONFLICT DO NOTHING;

-- If no client reports exist, add sample data
INSERT INTO public.client_reports (employee_name, attendance_id, client_name, report, created_at)
SELECT 
    'Louie',
    (SELECT id FROM public.attendance_records WHERE employee_name = 'Louie' LIMIT 1),
    'Client A',
    'Discussed project timeline and deliverables.',
    NOW() - (random() * interval '7 days')
FROM public.employees
WHERE name = 'Louie'
AND EXISTS (SELECT 1 FROM public.attendance_records WHERE employee_name = 'Louie')
ON CONFLICT DO NOTHING;

-- Verify data was added
SELECT '=== After Adding Sample Data ===' as info;
SELECT COUNT(*) as eod_reports_count FROM public.eod_reports;
SELECT COUNT(*) as client_reports_count FROM public.client_reports;
