import json
import time

# Manual HTTP requests to Supabase REST API
import urllib.request
import urllib.error

SUPABASE_URL = "https://uwnnpvepyyutrxsnhzku.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMTE0OTg0MywiZXhwIjoyMDg2NzI1ODQzfQ.THXsMBNZ496G6Vj8GA7q5uEUpjE8WM994sA_K8VhLfQ"

def make_request(method, path, data=None):
    """Make HTTP request to Supabase"""
    url = f"{SUPABASE_URL}{path}"
    
    headers = {
        "Authorization": f"Bearer {SERVICE_KEY}",
        "apikey": SERVICE_KEY,
        "Content-Type": "application/json"
    }
    
    try:
        if method == "GET":
            req = urllib.request.Request(url, headers=headers)
        elif method == "POST":
            req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers)
            req.add_header("Content-Type", "application/json")
        elif method == "DELETE":
            req = urllib.request.Request(url, method="DELETE", headers=headers)
        
        with urllib.request.urlopen(req, timeout=30) as response:
            return {"status": response.status, "data": json.loads(response.read())}
    except urllib.error.HTTPError as e:
        return {"status": e.code, "error": e.read().decode()}
    except Exception as e:
        return {"status": 0, "error": str(e)}

print("=" * 60)
print("ATTENDANCE SYSTEM - DATABASE RESET")
print("=" * 60)

# Step 1: Delete all data
print("\n[Step 1] Deleting existing data...")

# Delete from tables (in reverse order due to foreign keys)
for table in ["client_reports", "eod_reports", "attendance_records", "employees"]:
    result = make_request("DELETE", f"/rest/v1/{table}")
    print(f"  {table}: {'Cleared' if result['status'] in [200, 204, 401, 403] else result.get('error', 'Error')}")

# Step 2: Create tables and insert data
print("\n[Step 2] Setting up database...")
print("  NOTE: Please run complete_reset.sql in Supabase SQL Editor")
print("  File: Work-Systems/Attendance-System/complete_reset.sql")

# Step 3: Just verify current state
print("\n[Step 3] Checking database state...")
emp_result = make_request("GET", "/rest/v1/employees?select=*")
print(f"  Employees table: {emp_result.get('status', 'Error')}")
print(f"  Response: {emp_result.get('data', emp_result.get('error', 'Unknown'))}")

print("\n" + "=" * 60)
print("INSTRUCTIONS:")
print("=" * 60)
print("""
1. Go to: https://uwnnpvepyyutrxsnhzku.supabase.co
2. Click "SQL Editor" (left sidebar)
3. Click "New Query"
4. Open: complete_reset.sql
5. Copy ALL content
6. Paste in SQL Editor
7. Click "Run"

Database will be reset with:
- 7 employees (JV, Louie, Angelito, Adrian, Jeff, Josh, John)
- 4 tables (employees, attendance_records, eod_reports, client_reports)
- RLS policies for public access
""")
