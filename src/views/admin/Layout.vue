<template>
  <div class="flex h-screen bg-gray-50">
    <!-- Mobile Top Appbar -->
    <header
      v-if="isMobile"
      class="fixed top-0 left-0 right-0 z-50 bg-gradient-to-r from-primary-600 to-primary-700 text-white shadow-lg"
    >
      <div class="flex items-center justify-between px-4 py-3">
        <div class="flex items-center gap-3">
          <img src="/asset/logo.png" alt="KOK4INSTUDIO" class="h-8 w-auto">
        </div>
        <div class="flex items-center gap-2">
          <span class="text-sm font-medium">{{ currentPageTitle }}</span>
          <button @click="handleLogout" class="p-2 rounded-lg hover:bg-white/20 transition-colors">
            <span class="material-icons-round text-xl">logout</span>
          </button>
        </div>
      </div>
    </header>

    <!-- Sidebar (Desktop Only) -->
    <aside
      v-if="!isMobile"
      ref="sidebar"
      class="relative z-50 bg-white border-r border-gray-100 flex flex-col h-full transition-all duration-300 shadow-xl"
      :class="sidebarOpen ? 'w-72' : 'w-20'"
    >
      <!-- Logo Area -->
      <div class="p-6 border-b border-gray-100 bg-white">
        <div class="flex items-center gap-3">
          <img src="/asset/logo.png" alt="KOK4INSTUDIO" class="h-10 w-auto">
        </div>
      </div>
      
      <!-- Navigation -->
      <nav class="flex-1 py-6 overflow-y-auto px-4">
        <p v-if="sidebarOpen" class="text-xs font-bold text-gray-400 uppercase tracking-wider px-2 mb-4">Main Menu</p>
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-600 transition-all hover:bg-primary-50 hover:text-primary-700 mb-2 group"
          :class="{ 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-200': isActive(item.path)}"
        >
          <span class="material-icons-round text-xl">{{ item.icon }}</span>
          <span v-if="sidebarOpen" class="flex-1 text-sm font-medium">{{ item.label }}</span>
          <span v-if="isActive(item.path) && sidebarOpen" class="material-icons-round text-sm">chevron_right</span>
        </router-link>
      </nav>
      
      <!-- User Area -->
      <div class="p-5 border-t border-gray-100 bg-gradient-to-t from-gray-50 to-white">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center shadow-lg shadow-primary-200">
            <span class="material-icons-round text-white text-xl">person</span>
          </div>
          <div v-if="sidebarOpen" class="flex-1 min-w-0">
            <p class="text-sm font-bold text-gray-800 truncate">Admin</p>
            <p class="text-xs text-gray-500 truncate">admin@kok4instudio.com</p>
          </div>
          <button v-if="sidebarOpen" @click="handleLogout" class="text-gray-500 hover:text-red-600 p-2 hover:bg-red-50 rounded-xl transition-all">
            <span class="material-icons-round text-xl">logout</span>
          </button>
        </div>
      </div>
    </aside>
    
    <!-- Main Content -->
    <main class="flex-1 overflow-y-auto" :class="{ 'pt-16 pb-20': isMobile }">
      <!-- Desktop Header -->
      <header v-if="!isMobile" class="bg-white/90 backdrop-blur-xl border-b border-gray-100 px-8 py-5 flex items-center justify-between sticky top-0 z-30">
        <div class="flex items-center gap-3">
          <button @click="sidebarOpen = !sidebarOpen" class="p-2 rounded-lg hover:bg-gray-100 transition-colors">
            <span class="material-icons-round text-gray-600 text-2xl">{{ sidebarOpen ? 'menu_open' : 'menu' }}</span>
          </button>
          <div class="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl flex items-center justify-center">
            <span class="material-icons-round text-white text-xl">{{ currentPageIcon }}</span>
          </div>
          <div>
            <h2 class="font-display text-xl font-bold text-gray-800">{{ currentPageTitle }}</h2>
            <p class="text-xs text-gray-500">{{ new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}}</p>
          </div>
        </div>
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded-xl">
            <span class="material-icons-round text-primary-600 text-xl">schedule</span>
            <span class="text-sm text-gray-600 font-medium" id="current-time"></span>
          </div>
        </div>
      </header>
      
      <!-- Page Content -->
      <div class="p-4 md:p-8">
        <router-view />
      </div>
    </main>

    <!-- Mobile Bottom Navbar -->
    <nav
      v-if="isMobile"
      class="fixed bottom-0 left-0 right-0 z-50 bg-white border-t border-gray-100 shadow-lg"
    >
      <div class="flex items-center justify-around py-2">
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all"
          :class="{ 'text-primary-600': isActive(item.path), 'text-gray-500': !isActive(item.path) }"
        >
          <span class="material-icons-round text-2xl">{{ item.icon }}</span>
          <span class="text-xs font-medium">{{ item.label }}</span>
        </router-link>
      </div>
    </nav>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { gsap } from 'gsap'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const sidebarOpen = ref(true)
const sidebar = ref(null)
const isMobile = ref(window.innerWidth < 768)
let timeInterval = ref(null)

const menuItems = [
  { path: '/admin', label: 'Overview', icon: 'space_dashboard' },
  { path: '/admin/products', label: 'Produk', icon: 'inventory_2' },
  { path: '/admin/analytics', label: 'Analitik', icon: 'analytics' },
  { path: '/admin/audit-logs', label: 'Registration Log', icon: 'history' }
]

const currentPageTitle = computed(() => {
  const item = menuItems.find(i => i.path === route.path)
  return item?.label || 'Overview'
})

const currentPageIcon = computed(() => {
  const item = menuItems.find(i => i.path === route.path)
  return item?.icon || 'space_dashboard'
})

function isActive(path) {
  return route.path === path
}

async function handleLogout() {
  await authStore.signOut()
  router.push('/')
}

function updateTime() {
  const timeEl = document.getElementById('current-time')
  if (timeEl) {
    timeEl.textContent = new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
  }
}

function handleResize() {
  isMobile.value = window.innerWidth < 768
  if (!isMobile.value) {
    sidebarOpen.value = true
  }
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
  handleResize()

  timeInterval.value = setInterval(updateTime, 1000)
  updateTime()

  gsap.fromTo(
    sidebar.value,
    { x: -50, opacity: 0 },
    { x: 0, opacity: 1, duration: 0.5, ease: 'power3.out' }
  )
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  if (timeInterval.value) {
    clearInterval(timeInterval.value)
  }
})
</script>
