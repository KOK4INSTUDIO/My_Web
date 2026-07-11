# KOK41STUDIO™ Setup Guide

## 📁 Project Structure

```
kok4ins/
├── src/
│   ├── views/
│   │   ├── Home.vue
│   │   └── admin/
│   │       ├── Login.vue
│   │       ├── Layout.vue
│   │       ├── Dashboard.vue
│   │       ├── Products.vue
│   │       ├── PreOrders.vue
│   │       └── Analytics.vue
│   ├── router/
│   │   └── index.js
│   ├── stores/
│   │   └── auth.js
│   ├── lib/
│   │   └── supabase.js
│   ├── App.vue
│   ├── main.js
│   └── style.css
├── supabase/
│   └── migrations/
│       └── 001_init.sql
├── index.html
├── vite.config.js
├── tailwind.config.js
├── postcss.config.js
├── package.json
└── .env
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Supabase

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project (tkehgxyjkhtbauxsdqqz)
3. Go to **Project Settings > API**
4. Copy your **anon public** key
5. Update `.env` file:

```env
VITE_SUPABASE_URL=https://tkehgxyjkhtbauxsdqqz.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 3. Run Database Migration

#### Option A: Using Supabase CLI

```bash
# Install Supabase CLI if not installed
npm install -g supabase

# Link project
supabase link --project-ref tkehgxyjkhtbauxsdqqz

# Push migration
supabase db push
```

#### Option B: Manual SQL Execution

1. Go to **Supabase Dashboard > SQL Editor**
2. Create new query
3. Copy and paste content from `supabase/migrations/001_init.sql`
4. Run the query

### 4. Create Admin User

1. Go to **Supabase Dashboard > Authentication > Users**
2. Click **Add user > Create new user**
3. Enter email and password for admin
4. Click **Create user**

### 5. Start Development Server

```bash
npm run dev
```

Visit http://localhost:3000

## 📊 Features

### Admin Dashboard (`/admin`)
- Statistics cards (Total Products, Active Pre-Orders, Total Views, Low Stock)
- Recent pre-orders list
- Quick actions

### Products Management (`/admin/products`)
- Product catalog table
- Status badges
- Stock alerts

### Pre-Orders Management (`/admin/pre-orders`)
- Pre-orders table
- Status management
- Platform tracking

### Analytics (`/admin/analytics`)
- Page views statistics
- Product views
- Platform clicks
- Top products
- Device types

## 🎨 Design System

- **Colors**: Monochromatic (Black #0A0A0A, Dark #1A1A1A, Medium #6B6B6B, Border #D4D4D4, Surface #F5F5F5, White #FFFFFF)
- **Fonts**: Inter (sans-serif), Plus Jakarta Sans (display)
- **Dark Mode**: Class-based toggle

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- Authenticated users only for admin operations
- Public read access for products/categories/banners
- Public insert access for pre-orders and visitor events

## 📦 Deployment

Build for production:

```bash
npm run build
```

Deploy to Vercel:
- Push to main branch
- Vercel will auto-deploy
- Set environment variables in Vercel dashboard
