# Laravel + Tailwind CSS Setup Guide

## ✅ Apa yang sudah diinstall:

1. **Laravel 9.5.2** - PHP Web Framework
2. **Tailwind CSS 3.3.0** - Utility-first CSS Framework
3. **Vite 4.0.0** - Modern build tool
4. **PostCSS & Autoprefixer** - CSS processing

## 📦 File Konfigurasi yang sudah dibuat:

- ✓ `tailwind.config.js` - Konfigurasi Tailwind CSS
- ✓ `postcss.config.js` - PostCSS configuration
- ✓ `package.json` - Dependencies (termasuk tailwindcss)
- ✓ `resources/css/app.css` - Main CSS file dengan Tailwind directives
- ✓ `resources/views/welcome.blade.php` - Example page dengan Tailwind CSS
- ✓ `vite.config.js` - Vite configuration (sudah termasuk CSS)

## 🚀 Langkah Selanjutnya (PENTING):

### 1. Install Node.js dan npm
Tailwind CSS memerlukan Node.js dan npm untuk build process:
- Download dari: https://nodejs.org/ (gunakan LTS version)
- Install sesuai dengan sistem operasi Anda (Windows installer tersedia)

### 2. Install npm Dependencies
Setelah Node.js terinstall, buka terminal di folder project dan jalankan:
```bash
npm install
```

Perintah ini akan install semua packages yang ada di package.json, termasuk:
- tailwindcss
- postcss
- autoprefixer
- vite
- laravel-vite-plugin

### 3. Jalankan Development Server
Untuk development, gunakan:
```bash
npm run dev
```

Server akan berjalan di `http://localhost:5173` (Vite default port)

### 4. Build untuk Production
Ketika siap deploy:
```bash
npm run build
```

Ini akan generate optimized CSS dan JS files di `public` folder.

## 📝 Struktur File CSS

File `resources/css/app.css` berisi:
```css
@tailwind base;      /* Base styles */
@tailwind components; /* Component utilities */
@tailwind utilities;  /* Utility classes */
```

## 🎨 Menggunakan Tailwind CSS dalam Views

Sudah tersedia contoh di `resources/views/welcome.blade.php` yang menunjukkan:
- Layout dengan Tailwind classes
- Responsive design (md: breakpoint)
- Hover effects
- Color utilities
- Spacing utilities
- Gradient backgrounds

Contoh penggunaan:
```blade
<div class="bg-white rounded-lg shadow-lg hover:shadow-xl transition p-6">
    <h3 class="text-xl font-bold text-gray-900">Judul</h3>
    <p class="text-gray-600">Deskripsi</p>
</div>
```

## 🔧 Konfigurasi Tailwind CSS

File `tailwind.config.js` mengkonfigurasi:
- Content paths: `resources/views/**/*.blade.php` (untuk purge unused CSS)
- Theme customization (dapat di-extend sesuai kebutuhan)
- Plugins (dapat menambahkan Tailwind plugins di sini)

## 📚 Resources Berguna:

- Tailwind CSS Docs: https://tailwindcss.com/docs
- Laravel Docs: https://laravel.com/docs
- Vite Docs: https://vitejs.dev/
- Laracasts: https://laracasts.com

## 🔑 Penting untuk Diingat:

1. **Development vs Production**: 
   - Gunakan `npm run dev` untuk development dengan hot reload
   - Gunakan `npm run build` untuk production build

2. **CSS tidak akan ter-render tanpa npm build**:
   - Sebelum Node.js terinstall, Tailwind CSS tidak akan bekerja
   - Setelah `npm install`, jalankan `npm run dev` untuk development

3. **File yang di-track oleh npm**:
   - `node_modules/` folder (jangan di-upload ke git)
   - `package-lock.json` (seharusnya di-upload)

4. **Untuk local development**:
   - Buka 2 terminal: satu untuk `npm run dev` dan satu untuk `php artisan serve`
   - Atau akses via XAMPP dengan configured virtual host

## 💡 Tips:

- Jika CSS tidak update, coba clear cache: `npm run build && php artisan cache:clear`
- Untuk custom colors, edit `tailwind.config.js` di section `theme.extend.colors`
- Gunakan `@apply` directive di CSS files untuk reusable component styles

## ✨ Sekarang siap untuk development!

Setelah Node.js terinstall dan `npm install` dijalankan, Anda siap mulai develop dengan Laravel + Tailwind CSS!
