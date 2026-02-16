import requests
import json
import time

# Supabase configuration
SUPABASE_URL = "https://uwnnpvepyyutrxsnhzku.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMTE0OTg0MywiZXhwIjoyMDg2NzI1ODQzfQ.THXsMBNZ496G6Vj8GA7q5uEUpjE8WM994sA_K8VhLfQ"

headers = {
    "Authorization": f"Bearer {SERVICE_KEY}",
    "Content-Type": "application/json",
    "apikey": SERVICE_KEY
}

def delete_table(table_name):
    """Delete all rows from a table"""
    print(f"Deleting from {table_name}...")
    response = requests.delete(
        f"{SUPABASE_URL}/rest/v1/{table_name}",
        headers=headers
    )
    print(f"  Status: {response.status_code}")

def insert_employee(name, emp_type, role):
    """Insert an employee"""
    print(f"  Inserting: {name} ({emp_type})")
    response = requests.post(
        f"{SUPABASE_URL}/rest/v1/employees",
        headers=headers,
        json={"name": name, "type": emp_type, "role": role}
    )
    if response.status_code in [200, 201]:
        print(f"    OK: {name}")
    else:
        print(f"    Error: {response.text[:100]}")

def verify_table(table_name):
    """Verify table contents"""
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/{table_name}",
        headers=headers
    )
    data = response.json() if response.status_code == 200 else []
    print(f"  {table_name}: {len(data)} records")
    return data

print("=" * 60)
print("ATTENDANCE SYSTEM - DATABASE RESET")
print("=" * 60)

# Step 1: Delete existing data
print("\n[Step 1] Clearing existing data...")
delete_table("client_reports")
delete_table("eod_reports")
delete_table("attendance_records")
delete_table("employees")

# Step 2: Insert employees
print("\n[Step 2] Inserting employees...")
employees = [
    ("JV", "owner", "Business Owner"),
    ("Louie", "manager", "Business Manager"),
    ("Angelito", "regular", "Video Editor"),
    ("Adrian", "regular", "Video Editor"),
    ("Jeff", "regular", "Video Editor"),
    ("Josh", "regular", "Video Editor"),
    ("John", "regular", "Video Editor"),
]

for name, emp_type, role in employees:
    insert_employee(name, emp_type, role)

# Step 3: Verify
print("\n[Step 3] Verifying tables...")
print("\n" + "=" * 60)
print("DATABASE RESET COMPLETE!")
print("=" * 60)
print(f"\nEmployees: {len(verify_table('employees'))}")
print(f"Attendance Records: {len(verify_table('attendance_records'))}")
print(f"EOD Reports: {len(verify_table('eod_reports'))}")
print(f"Client Reports: {len(verify_table('client_reports'))}")
