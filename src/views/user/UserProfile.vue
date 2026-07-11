<template>
  <div class="min-h-screen bg-gray-50">
    <!-- User Header -->
    <div class="bg-accent-black text-white py-12">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row items-center gap-6">
          <div class="w-24 h-24 rounded-full bg-white/20 flex items-center justify-center">
            <span class="material-icons-round text-5xl">person</span>
          </div>
          <div class="text-center sm:text-left">
            <h1 class="font-display text-3xl font-bold">Halo, User!</h1>
            <p class="text-gray-300">user@example.com</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Sidebar -->
        <div class="lg:col-span-1">
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <nav class="space-y-2">
              <router-link 
                to="/user/profile" 
                class="flex items-center gap-3 px-4 py-3 rounded-lg bg-accent-light text-accent-black font-medium"
              >
                <span class="material-icons-round">person</span>
                Profil
              </router-link>
              <router-link 
                to="/user/orders" 
                class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-50 font-medium transition-colors"
              >
                <span class="material-icons-round">shopping_bag</span>
                Pesanan Saya
              </router-link>
              <router-link 
                to="/user/bookings" 
                class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-50 font-medium transition-colors"
              >
                <span class="material-icons-round">event</span>
                Booking
              </router-link>
              <button class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 font-medium transition-colors mt-4">
                <span class="material-icons-round">logout</span>
                Keluar
              </button>
            </nav>
          </div>
        </div>

        <!-- Main Content -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Booking Section -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 class="font-display text-2xl font-bold text-accent-black mb-6 flex items-center gap-2">
              <span class="material-icons-round">event</span>
              Booking Produk
            </h2>

            <div class="space-y-4">
              <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Pilih Produk</label>
                <select class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors">
                  <option>KOK41NSTUDIO™ Night Vision Yellow Lens UV400</option>
                  <option>KOK41NSTUDIO™ Classic Black Sunglasses</option>
                  <option>KOK41NSTUDIO™ Aviator Polarized</option>
                </select>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-bold text-gray-700 mb-2">Tanggal Pengambilan</label>
                  <input type="date" class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors" />
                </div>
                <div>
                  <label class="block text-sm font-bold text-gray-700 mb-2">Jumlah</label>
                  <input type="number" value="1" min="1" class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors" />
                </div>
              </div>

              <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Catatan Tambahan</label>
                <textarea rows="3" class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors" placeholder="Catatan tambahan untuk pesanan..."></textarea>
              </div>

              <button class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-accent-black text-white font-bold hover:bg-accent-dark transition-colors">
                <span class="material-icons-round">book_online</span>
                Konfirmasi Booking
              </button>
            </div>
          </div>

          <!-- Recent Orders -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 class="font-display text-2xl font-bold text-accent-black mb-6 flex items-center gap-2">
              <span class="material-icons-round">history</span>
              Riwayat Pesanan
            </h2>

            <div class="space-y-4">
              <div class="flex items-center justify-between p-4 border border-gray-100 rounded-lg">
                <div>
                  <p class="font-medium text-accent-black">KOK41NSTUDIO™ Night Vision</p>
                  <p class="text-sm text-gray-500">Tanggal: 15 Juni 2026</p>
                </div>
                <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-bold rounded-full">Selesai</span>
              </div>
              <div class="flex items-center justify-between p-4 border border-gray-100 rounded-lg">
                <div>
                  <p class="font-medium text-accent-black">KOK41NSTUDIO™ Classic Black</p>
                  <p class="text-sm text-gray-500">Tanggal: 10 Juni 2026</p>
                </div>
                <span class="px-3 py-1 bg-yellow-100 text-yellow-700 text-xs font-bold rounded-full">Diproses</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
</script>
