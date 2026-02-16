# 📋 Attendance System

A complete Check-in/Check-out system with EOD Reports for regular employees and Client Reports for business managers (like Louie).

---

## 📁 Project Structure

```
Desktop/Clawdette Files/Attendance-System/
├── index.html              # Check-in/Check-out page
├── admin.html              # Admin dashboard
├── supabase_schema.sql     # Database setup script
└── README.md               # This file
```

---

## 🚀 Quick Setup Guide

### Step 1: Set Up Supabase Database

1. Go to: https://owocuvkufkgsxovdkmqs.supabase.co
2. Click **SQL Editor** (left sidebar)
3. Click **New query**
4. Open `supabase_schema.sql` and copy ALL content
5. Paste into Supabase SQL Editor
6. Click **Run**
7. You should see success messages

### Step 2: Get Your Service Role Key

1. In Supabase, go to **Settings** (⚙️ icon, bottom left)
2. Click **API**
3. Copy the **service_role** key
4. Open `admin.html`
5. Find: `SUPABASE_SERVICE_KEY = '...'`
6. Replace the placeholder with your actual service role key

### Step 3: Test Locally

Double-click `index.html` to open in your browser.

---

## 👥 How It Works

### Check In / Check Out

1. **Select your name** from the dropdown (automatically populated from registered employees)
2. **Click Check In** - your status updates to "Checked In"
3. **At end of day** - Click **Check Out**
4. **Fill out report** based on your employee type
5. **Submit** - Done!

### Self-Registration

New employees can **"Register Here"** link at the bottom:

1. Click **"Register Here"**
2. Fill in:
   - Full Name
   - Employee Type:
     - **Regular** → EOD Reports (videos, revisions)
     - **Manager** → Client Reports
   - Role/Title (for managers)
3. Click **Register**
4. Now you can select your name and check in!

### Regular Employees (EOD Reports)

1. **Check In:**
   - Select your name
   - Click "Check In" button
   - Status changes to "Checked In"

2. **Check Out:**
   - Click "Check Out" button
   - **EOD Report modal opens** with:
     - What videos did you do today?
     - What revisions did you do today?
     - Number of new videos edited
   - Submit to complete check out

### Louie (Business Manager)

1. **Check In:**
   - Select "Louie (Business Manager)"
   - Click "Check In"

2. **Check Out:**
   - Click "Check Out" button
   - **Client Reports modal opens** with:
     - Dynamic client boxes (add/remove as needed)
     - Select or enter client name
     - Report text area for each client
   - Submit to complete check out

---

## 📊 Admin Dashboard

Access at: `admin.html`

**Tabs:**
- **📋 Attendance** - View all check-in/check-out records with duration
- **📝 EOD Reports** - View all employee EOD reports
- **👥 Client Reports** - View Louie's client reports

**Features:**
- Filter by date, employee, status
- Statistics (checked in, checked out today, avg hours)
- Clean table view with all details

---

## 🌐 Deploy to Your Domain

### Option A: Netlify (Recommended - Free)

1. **Prepare your files:**
   ```
   Attendance-System/
   ├── index.html
   ├── admin.html
   └── supabase_schema.sql
   ```

2. **Create Netlify site:**
   - Go to: https://netlify.com
   - Sign up/Login with GitHub
   - Click "Add new site" → "Deploy manually"
   - Drag and drop the `Attendance-System` folder
   - Netlify will give you a URL

3. **Custom Domain:**
   - Go to **Site Settings** → **Domain Management**
   - Click "Add custom domain"
   - Enter your domain

### Option B: Vercel (Also Free)

```powershell
cd "Desktop/Clawdette Files/Attendance-System"
npx vercel --prod
```

### Option C: GitHub Pages

1. Create a new GitHub repository
2. Upload files (index.html, admin.html)
3. Go to **Settings** → **Pages**
4. Select "main" branch → Save

---

## 🔐 Security Notes

| File | Key Type | Safe to Share? |
|------|----------|----------------|
| `index.html` | Anon Key (public) | ✅ Yes |
| `admin.html` | Service Key (secret) | ❌ No |

**Important:**
- Never commit `admin.html` with real keys to public repos
- The service role key gives FULL database access
- Keep it secure!

---

## 👥 Employee List (Self-Registered)

Employees now **register themselves** using the "Register Here" link on the main page!

**Employee Types:**
- **Regular** → Gets EOD Report form on check-out
- **Manager** → Gets Client Report form on check-out (like Louie)

**Default Employees (pre-seeded):**
- MangJose (Team Lead)
- Jhay-R (Video Editor)
- Jocelyn (Video Editor)
- KC (Video Editor)
- Rex (Video Editor)
- Louie (Business Manager - Manager type)

---

## 🛠️ Troubleshooting

### "Error during check-in"

**Cause:** Database connection or RLS policy issue.

**Fix:**
1. Check Supabase URL is correct in both files
2. Run the SQL schema again
3. Check browser console for details

### Client reports not saving

**Cause:** Service role key missing or incorrect.

**Fix:**
1. Get fresh service role key from Supabase Settings → API
2. Update `admin.html` with the new key

### Modal not opening

**Cause:** JavaScript error.

**Fix:**
1. Open browser developer console (F12)
2. Check for error messages
3. Make sure Supabase JS is loading

---

## 📱 Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge

Works on desktop and mobile browsers.

---

## 📞 Support

Questions? Issues? Ping mangjose on Discord.

---

**Built with ❤️ for the team**
