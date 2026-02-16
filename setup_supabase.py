import requests
import sys

# Supabase configuration - use ANON key for REST API
SUPABASE_URL = "https://uwnnpvepyyutrxsnhzku.supabase.co"
ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExNDk4NDMsImV4cCI6MjA4NjcyNTg0M30.qbf1dnPQ8srUc2EcwNHNz3HFz3v5_A7gKUS1ZWKV7vM"

def get_headers():
    return {
        "apiKey": ANON_KEY,
        "Authorization": f"Bearer {ANON_KEY}",
        "Content-Type": "application/json",
    }

def insert_employees():
    """Insert default employees"""
    employees = [
        {"name": "JV", "type": "owner", "role": "Business Owner"},
        {"name": "Louie", "type": "manager", "role": "Business Manager"},
        {"name": "Angelito", "type": "regular", "role": "Video Editor"},
        {"name": "Adrian", "type": "regular", "role": "Video Editor"},
        {"name": "Jeff", "type": "regular", "role": "Video Editor"},
        {"name": "Josh", "type": "regular", "role": "Video Editor"},
        {"name": "John", "type": "regular", "role": "Video Editor"},
    ]
    
    print("\nInserting employees...")
    success_count = 0
    for emp in employees:
        url = f"{SUPABASE_URL}/rest/v1/employees"
        response = requests.post(url, json=emp, headers=get_headers())
        status = response.status_code
        if status in [200, 201]:
            print(f"  [OK] {emp['name']}")
            success_count += 1
        elif status == 409:
            print(f"  [--] {emp['name']} (already exists)")
            success_count += 1
        else:
            print(f"  [XX] {emp['name']}: {status}")
    
    return success_count

def check_connection():
    """Check if we can connect"""
    print("Testing connection...")
    url = f"{SUPABASE_URL}/rest/v1/employees?select=count"
    response = requests.get(url, headers=get_headers())
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        print(f"Response: {response.text}")
    return response.status_code == 200

def main():
    print("=" * 50)
    print("Supabase Database Setup")
    print("=" * 50)
    
    if check_connection():
        count = insert_employees()
        print(f"\n{count}/7 employees inserted/exists")
    else:
        print("\nCannot connect!")
        print("Note: Tables must be created first in Supabase Dashboard")
    
    print("\n" + "=" * 50)

if __name__ == "__main__":
    main()
