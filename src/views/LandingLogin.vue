<template>
  <div class="min-h-screen bg-gradient-to-br from-white via-primary-50 to-white relative overflow-hidden">
    <!-- Decorative elements -->
    <div class="absolute top-0 left-0 w-72 h-72 bg-primary-200 rounded-full blur-3xl opacity-60 -translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-primary-300 rounded-full blur-3xl opacity-40 translate-x-1/3 translate-y-1/3"></div>
    
    <div class="relative z-10 min-h-screen flex items-center justify-center px-4 py-12">
      <div class="max-w-6xl w-full">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <!-- Left Side - Hero Content -->
          <div class="text-center lg:text-left space-y-8">
            <!-- Logo -->
            <div class="flex items-center justify-center lg:justify-start gap-3">
              <div class="w-16 h-16 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center shadow-red">
                <span class="material-icons-round text-white text-3xl">shopping_bag</span>
              </div>
              <span class="font-display text-3xl font-bold text-accent-dark">KOK4INSTUDIO</span>
            </div>

            <!-- Headline -->
            <div class="space-y-4">
              <h1 class="font-display text-5xl md:text-6xl font-bold leading-tight">
                <span class="text-accent-dark">Temukan Gaya</span>
                <br>
                <span class="text-primary-600">Anda yang Keren!</span>
              </h1>
              <p class="text-xl text-accent-gray max-w-lg">
                Koleksi kacamata dan aksesori premium dengan kualitas terbaik untuk tampil percaya diri setiap hari.
              </p>
            </div>

            <!-- Features -->
            <div class="grid grid-cols-2 gap-4 max-w-md mx-auto lg:mx-0">
              <div class="bg-white p-4 rounded-xl border border-primary-100 shadow-soft">
                <div class="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center mb-3">
                  <span class="material-icons-round text-primary-600">verified</span>
                </div>
                <h3 class="font-semibold text-accent-dark">Produk Premium</h3>
                <p class="text-sm text-accent-gray">Kualitas terjamin</p>
              </div>
              <div class="bg-white p-4 rounded-xl border border-primary-100 shadow-soft">
                <div class="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center mb-3">
                  <span class="material-icons-round text-primary-600">local_shipping</span>
                </div>
                <h3 class="font-semibold text-accent-dark">Pengiriman Cepat</h3>
                <p class="text-sm text-accent-gray">Seluruh Indonesia</p>
              </div>
            </div>
          </div>

          <!-- Right Side - Auth Card -->
          <div class="relative">
            <div class="absolute -inset-1 bg-gradient-to-r from-primary-500 to-primary-600 rounded-3xl blur opacity-25"></div>
            <div class="relative bg-white p-8 md:p-10 rounded-3xl shadow-xl border border-primary-100">
              <div class="text-center mb-8">
                <div class="w-20 h-20 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-red">
                  <span class="material-icons-round text-white text-4xl">lock</span>
                </div>
                <h2 class="font-display text-3xl font-bold text-accent-dark">
                  Selamat Datang!
                </h2>
                <p class="text-accent-gray mt-2">
                  Pilih akses untuk melanjutkan
                </p>
              </div>

              <div class="space-y-4">
                <!-- User Login -->
                <router-link 
                  to="/user/login" 
                  class="flex items-center justify-center gap-3 w-full px-8 py-5 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-bold rounded-2xl hover:from-primary-600 hover:to-primary-700 transition-all shadow-red hover:shadow-xl transform hover:-translate-y-1"
                >
                  <span class="material-icons-round text-2xl">person</span>
                  <span>Masuk sebagai User</span>
                </router-link>
                
                <!-- Divider -->
                <div class="flex items-center gap-4 my-6">
                  <div class="flex-1 h-px bg-gradient-to-r from-transparent via-primary-200 to-transparent"></div>
                  <span class="text-accent-gray font-medium">atau</span>
                  <div class="flex-1 h-px bg-gradient-to-r from-transparent via-primary-200 to-transparent"></div>
                </div>

                <!-- Admin Login -->
                <router-link 
                  to="/admin/login" 
                  class="flex items-center justify-center gap-3 w-full px-8 py-5 border-2 border-primary-200 text-accent-dark font-bold rounded-2xl hover:bg-primary-50 hover:border-primary-300 transition-all transform hover:-translate-y-0.5"
                >
                  <span class="material-icons-round text-2xl text-primary-600">admin_panel_settings</span>
                  <span>Masuk sebagai Admin</span>
                </router-link>

                <!-- Register User -->
                <div class="text-center pt-6 border-t border-gray-100">
                  <p class="text-accent-gray">
                    Belum punya akun?
                    <router-link to="/user/register" class="text-primary-600 font-bold hover:text-primary-700 hover:underline ml-1">
                      Daftar sekarang
                    </router-link>
                  </p>
                </div>
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
