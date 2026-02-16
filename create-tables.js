const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://uwnnpvepyyutrxsnhzku.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3bm5wdmVweXl1dHJ4c25oemt1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMTE0OTg0MywiZXhwIjoyMDg2NzI1ODQzfQ.THXsMBNZ496G6Vj8GA7q5uEUpjE8WM994sA_K8VhLfQ';

const supabase = createClient(supabaseUrl, supabaseKey);

async function setupDatabase() {
    console.log('Setting up Supabase database...\n');

    // Create employees table
    console.log('1. Creating employees table...');
    const { error: empError } = await supabase.rpc('create_employees_table', {});
    if (empError) {
        // Try direct SQL
        const { error: empSql } = await supabase.from('employees').select('*').limit(1);
        if (empSql && empSql.message.includes('does not exist')) {
            console.log('   Table does not exist, creating via SQL...');
            // We can't run raw SQL through the JS client easily
            console.log('   Please run the SQL in Supabase Dashboard');
        } else {
            console.log('   Employees table OK');
        }
    } else {
        console.log('   Employees table OK');
    }

    // Insert default employees
    console.log('\n2. Inserting default employees...');
    const employees = [
        { name: 'JV', type: 'owner', role: 'Business Owner' },
        { name: 'Louie', type: 'manager', role: 'Business Manager' },
        { name: 'Angelito', type: 'regular', role: 'Video Editor' },
        { name: 'Adrian', type: 'regular', role: 'Video Editor' },
        { name: 'Jeff', type: 'regular', role: 'Video Editor' },
        { name: 'Josh', type: 'regular', role: 'Video Editor' },
        { name: 'John', type: 'regular', role: 'Video Editor' }
    ];

    for (const emp of employees) {
        const { error } = await supabase.from('employees').upsert(emp, { onConflict: 'name' });
        if (error) {
            console.log(`   Error inserting ${emp.name}: ${error.message}`);
        } else {
            console.log(`   ✓ ${emp.name} inserted`);
        }
    }

    console.log('\n====================================');
    console.log('Setup complete!');
    console.log('====================================\n');
    console.log('Note: If tables were not created,');
    console.log('please run the SQL in Supabase Dashboard.');
}

setupDatabase().catch(console.error);
