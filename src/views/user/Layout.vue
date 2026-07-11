<template>
  <div class="min-h-screen bg-gradient-to-b from-white to-primary-50">
    <!-- Header -->
    <header class="bg-white/80 backdrop-blur-md border-b border-primary-100 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Logo -->
          <div class="flex items-center gap-2">
            <router-link to="/home" class="flex items-center gap-3">
              <img src="/asset/logo.png" alt="KOK41STUDIO" class="h-10 object-contain" />
            </router-link>
          </div>
          
          <!-- Desktop Nav -->
          <nav class="hidden md:flex items-center gap-8">
            <router-link to="/home" class="text-accent-gray hover:text-primary-600 font-medium text-sm transition-colors relative group">
              Home
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 transition-all group-hover:w-full"></span>
            </router-link>
            <router-link to="/home/products" class="text-accent-gray hover:text-primary-600 font-medium text-sm transition-colors relative group">
              Shop
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 transition-all group-hover:w-full"></span>
            </router-link>
            <router-link to="/home/about" class="text-accent-gray hover:text-primary-600 font-medium text-sm transition-colors relative group">
              About
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 transition-all group-hover:w-full"></span>
            </router-link>
            <router-link to="/home/contact" class="text-accent-gray hover:text-primary-600 font-medium text-sm transition-colors relative group">
              Contact
              <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 transition-all group-hover:w-full"></span>
            </router-link>
          </nav>
          
          <!-- Icons -->
          <div class="hidden md:flex items-center gap-4">
            <button @click="handleLogout" class="flex items-center gap-2 px-4 py-2 bg-primary-50 text-primary-700 hover:bg-primary-100 rounded-xl font-medium text-sm transition-all">
              <span class="material-icons-round text-lg">logout</span>
              Keluar
            </button>
          </div>
          
          <!-- Mobile Menu Button -->
          <button @click="mobileMenuOpen = !mobileMenuOpen" class="md:hidden p-2 text-accent-dark">
            <span class="material-icons-round text-3xl">{{ mobileMenuOpen ? 'close' : 'menu' }}</span>
          </button>
        </div>
        
        <!-- Mobile Menu -->
        <nav v-if="mobileMenuOpen" class="md:hidden py-6 border-t border-gray-200">
          <div class="flex flex-col gap-4">
            <router-link to="/home" @click="mobileMenuOpen = false" class="text-accent-dark font-medium text-lg">Home</router-link>
            <router-link to="/home/products" @click="mobileMenuOpen = false" class="text-accent-dark font-medium text-lg">Shop</router-link>
            <router-link to="/home/about" @click="mobileMenuOpen = false" class="text-accent-dark font-medium text-lg">About</router-link>
            <router-link to="/home/contact" @click="mobileMenuOpen = false" class="text-accent-dark font-medium text-lg">Contact</router-link>
            <div class="pt-4 border-t border-gray-100">
              <button @click="handleLogout" class="flex items-center gap-2 px-4 py-2 bg-primary-50 text-primary-700 rounded-xl font-medium text-sm">
                <span class="material-icons-round text-lg">logout</span>
                Keluar
              </button>
            </div>
          </div>
        </nav>
      </div>
    </header>
    
    <!-- Main Content -->
    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { supabase } from '@/lib/supabase'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const mobileMenuOpen = ref(false)

async function trackVisit(page) {
  try {
    await supabase.from('visitors').insert({
      page: page,
      user_agent: navigator.userAgent
    })
  } catch (e) {
    console.log('Tracking failed (optional):', e)
  }
}

onMounted(() => {
  trackVisit(route.path)
})

watch(() => route.path, (newPath) => {
  trackVisit(newPath)
})

async function handleLogout() {
  await authStore.signOut()
  router.push('/')
}
</script>
