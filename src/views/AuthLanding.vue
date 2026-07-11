<template>
  <div class="min-h-screen bg-accent-light flex items-center justify-center px-4">
    <div class="max-w-4xl w-full grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
      <!-- Info Side -->
          <h1 class="font-display text-4xl md:text-5xl font-bold text-accent-black mb-4">
          KOK41NSTUDIO™
        </h1>
      <div class="text-center lg:text-left">
        <img 
          src="https://i.imgur.com/l3v0q5b.png" 
          alt="KOK41NSTUDIO™ Logo" 
          class="h-16 w-auto mx-auto lg:mx-0 mb-6"
        />
        <p class="text-gray-600 text-lg mb-8">
          Brand fashion lokal premium untuk kacamata dan aksesori dengan kualitas terbaik.
        </p>
      </div>

      <!-- Pilihan Auth -->
      <div class="bg-white p-8 rounded-2xl shadow-xl border border-gray-200">
        <h2 class="font-display text-2xl font-bold text-accent-black mb-8 text-center">
          Pilih Akses
        </h2>
        <div class="space-y-4">
          <!-- User Login -->
          <router-link 
            to="/user/login" 
            class="flex items-center justify-center gap-3 w-full px-8 py-4 bg-accent-black text-white font-bold hover:bg-accent-dark transition-colors"
          >
            <span class="material-icons-round">person</span>
            Masuk sebagai User
          </router-link>
          
          <!-- User Register -->
          <router-link 
            to="/user/register" 
            class="flex items-center justify-center gap-3 w-full px-8 py-4 border border-gray-300 text-accent-black font-bold hover:bg-gray-50 transition-colors"
          >
            <span class="material-icons-round">person_add</span>
            Daftar User Baru
          </router-link>

          <div class="flex items-center gap-4 my-6">
            <div class="flex-1 h-px bg-gray-200"></div>
            <span class="text-gray-500 text-sm">atau</span>
            <div class="flex-1 h-px bg-gray-200"></div>
          </div>

          <!-- Admin Login -->
          <router-link 
            to="/admin/login" 
            class="flex items-center justify-center gap-3 w-full px-8 py-4 bg-gray-800 text-white font-bold hover:bg-gray-900 transition-colors"
          >
            <span class="material-icons-round">admin_panel_settings</span>
            Admin Dashboard
          </router-link>
        </div>

        <div class="mt-6 text-center">
          <router-link to="/" class="text-gray-500 text-sm hover:text-accent-black hover:underline">
            <span class="material-icons-round text-sm align-middle">arrow_back</span>
            Kembali ke Beranda
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
</script>
