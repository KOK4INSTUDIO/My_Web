# 🚀 VERCEL DEPLOYMENT GUIDE

## 📋 Persiapan untuk Hosting di Vercel

Vercel adalah platform hosting modern yang mendukung frontend frameworks. Proyek ini menggunakan **Vite + Tailwind CSS** yang fully compatible dengan Vercel.

---

## ✅ Checklist Pre-Deployment

- [x] Vite configuration (vite.config.js) ✓
- [x] Tailwind CSS configured ✓
- [x] npm dependencies fixed ✓
- [x] vercel.json created ✓
- [x] .gitignore properly configured ✓
- [x] Build script ready (`npm run build`) ✓

---

## 🔧 Setup untuk Vercel

### 1. Install Vercel CLI (Optional)
```bash
npm install -g vercel
```

### 2. Login ke Vercel
```bash
vercel login
```

### 3. Deploy ke Vercel

**Opsi A: Manual via Vercel Dashboard**
1. Buka https://vercel.com
2. Click "Add New Project"
3. Import GitHub repository (atau upload folder)
4. Vercel akan auto-detect Vite framework
5. Click Deploy

**Opsi B: Via CLI**
```bash
vercel
```

---

## 📝 Build Configuration

**Build Command:** 
```bash
npm run build
```

**Output Directory:** 
```
public/dist
```

**Install Command:** 
```bash
npm install
```

---

## 🔐 Environment Variables

Jika project menggunakan environment variables, setup di Vercel Dashboard:
1. Project Settings → Environment Variables
2. Tambah variable seperti di `.env` file
3. Vercel akan inject saat build time

**Contoh:**
```
VITE_API_URL=https://api.example.com
VITE_APP_NAME=MyApp
```

---

## ⚠️ PENTING: Backend (Laravel) Setup

**Catatan:** Vercel adalah hosting untuk **Frontend Only**. Jika Anda membutuhkan backend Laravel:

### Opsi 1: Frontend + Backend Terpisah (Recommended)
- Deploy Vite frontend ke Vercel
- Deploy Laravel backend ke:
  - Heroku (PHP support)
  - AWS Lightsail
  - DigitalOcean
  - Shared hosting biasa (cPanel)
  - Railway.app

### Opsi 2: Full-Stack di Vercel (Serverless Functions)
Gunakan Vercel Serverless Functions untuk API:
```
api/
  ├── index.ts
  ├── auth/
  └── users/
```

### Opsi 3: Gunakan Backend-as-a-Service
- Firebase
- Supabase
- AWS Amplify

---

## 🛠️ Recommended: Frontend Only di Vercel + Backend Terpisah

**Struktur untuk production:**

```
Frontend (Vercel):
├── resources/css/app.css
├── resources/views/welcome.blade.php → Converted to React/Vue
├── vite.config.js
└── package.json → Build output ke public/dist

Backend (Separate hosting):
├── app/
├── database/
├── routes/
└── composer.json → PHP MySQL database
```

---

## 📦 Tips Optimasi Vercel

1. **Bundle size** - Gunakan `npm run build` dan cek output size:
   ```bash
   npm run build
   ```

2. **Lazy loading** - Split code untuk faster loading:
   ```javascript
   import { lazy } from 'react';
   const Home = lazy(() => import('./pages/Home'));
   ```

3. **Image optimization** - Gunakan Next.js Image (jika upgrade ke Next.js):
   ```javascript
   import Image from 'next/image'
   ```

4. **Cache headers** - Vercel auto-handles caching untuk static assets

---

## 🚨 Common Issues & Solutions

### Issue 1: "Cannot find module"
**Solution:** 
```bash
npm install
npm run build
```

### Issue 2: Build fails with "postcss" error
**Solution:** Sudah fixed di package.json (added "type": "module")

### Issue 3: Environment variables not working
**Solution:** 
- Tambahkan `VITE_` prefix untuk client-side vars
- Setup di Vercel Dashboard Environment Variables

### Issue 4: CSS not loading
**Solution:**
```bash
npm run build  # Rebuild
```

---

## 📊 Vercel Performance Tips

1. **Edge Functions** - Deploy di edge untuk latency minimal
2. **ISR (Incremental Static Regeneration)** - Cache halaman
3. **Analytics** - Monitor performa via Vercel Analytics
4. **Observability** - Track errors via Sentry integration

---

## 🔄 Deployment Workflow

1. **Local development:**
   ```bash
   npm run dev
   ```

2. **Test build locally:**
   ```bash
   npm run build
   npm run preview
   ```

3. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push origin main
   ```

4. **Auto-deploy via Vercel GitHub integration** ✓

---

## 📞 Support

- Vercel Docs: https://vercel.com/docs
- Vite Docs: https://vitejs.dev/
- Tailwind CSS Docs: https://tailwindcss.com/

---

**Status:** ✅ Ready for Vercel Deployment!
