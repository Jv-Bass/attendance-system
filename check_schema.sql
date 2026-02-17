-- Check actual table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'eod_reports' 
ORDER BY ordinal_position;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'attendance_records' 
ORDER BY ordinal_position;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'client_reports' 
ORDER BY ordinal_position;
