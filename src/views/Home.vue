<template>
  <div class="min-h-screen bg-gray-100 flex items-center justify-center p-4">
    <div class="text-center">
      <div class="w-16 h-16 bg-gradient-to-br from-red-500 to-red-700 rounded-xl flex items-center justify-center mx-auto mb-5 shadow-md">
        <span class="material-icons-round text-white text-3xl">palette</span>
      </div>
      <h1 class="font-display text-2xl md:text-3xl font-bold text-black mb-3">KOK4INSTUDIO</h1>
      <p class="text-gray-600 mb-6 max-w-md mx-auto text-sm">Premium fashion & accessories store admin dashboard</p>
      <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <router-link to="/admin/login" class="bg-red-600 text-white px-5 py-2.5 font-bold rounded-lg flex items-center justify-center gap-2 transition-all hover:bg-red-700 shadow-md text-sm">
          <span class="material-icons-round">login</span>
          Admin Dashboard
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
// Home page
</script>
