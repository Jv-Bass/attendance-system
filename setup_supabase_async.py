import asyncio
from supabase import create_client, Client

# Supabase configuration
SUPABASE_URL = "https://uwnnpvepyyutrxsnhzku.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMTE0OTg0MywiZXhwIjoyMDg2NzI1ODQzfQ.THXsMBNZ496G6Vj8GA7q5uEUpjE8WM994sA_K8VhLfQ"

async def setup_database():
    print("=" * 50)
    print("Supabase Database Setup")
    print("=" * 50)
    
    try:
        supabase: Client = create_client(SUPABASE_URL, SERVICE_KEY)
        print("\nClient created successfully!")
        
        # Insert employees
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
        for emp in employees:
            result = supabase.table('employees').insert(emp).execute()
            print(f"  [OK] {emp['name']}")
        
        # Verify
        result = supabase.table('employees').select('*').execute()
        print(f"\nTotal employees: {len(result.data)}")
        
        print("\n" + "=" * 50)
        print("Setup complete!")
        print("=" * 50)
        
    except Exception as e:
        print(f"\nError: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(setup_database())
