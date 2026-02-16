import requests
import json

# Supabase configuration
SUPABASE_URL = "https://uwnnpvepyyutrxsnhzku.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMTE0OTg0MywiZXhwIjoyMDg2NzI1ODQzfQ.THXsMBNZ496G6Vj8GA7q5uEUpjE8WM994sA_K8VhLfQ"

# Read SQL file
with open('complete_reset.sql', 'r') as f:
    sql = f.read()

# Execute SQL
print("=" * 50)
print("Resetting Supabase Database...")
print("=" * 50)

headers = {
    "Authorization": f"Bearer {SERVICE_KEY}",
    "Content-Type": "application/json",
    "apikey": SERVICE_KEY
}

response = requests.post(
    f"{SUPABASE_URL}/rest/v1/rpc/execute_sql",
    headers=headers,
    json={"query": sql}
)

print(f"Status: {response.status_code}")
print(f"Response: {response.text}")

if response.status_code == 200:
    print("\n" + "=" * 50)
    print("Database reset successfully!")
    print("=" * 50)
else:
    print("\nError occurred!")
