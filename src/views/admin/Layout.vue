<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Mobile Sidebar Toggle -->
    <button
      v-if="isMobile"
      @click="sidebarOpen = !sidebarOpen"
      class="fixed top-3 left-3 z-50 bg-white border-2 border-black text-black p-2.5 rounded-lg shadow-md"
    >
      <span class="material-icons-round text-xl">menu</span>
    </button>

    <!-- Sidebar Overlay (mobile) -->
    <div
      v-if="sidebarOpen && isMobile"
      @click="sidebarOpen = false"
      class="fixed inset-0 bg-black/40 backdrop-blur-sm z-40"
    ></div>

    <!-- Sidebar -->
    <aside
      ref="sidebar"
      class="fixed md:relative z-50 w-64 bg-white border-r-2 border-black flex flex-col h-full transition-all duration-300"
      :class="{ 'translate-x-0': sidebarOpen, '-translate-x-full': !sidebarOpen && isMobile }"
    >
      <!-- Logo Area -->
      <div class="p-4 border-b-2 border-black flex items-center gap-2">
        <div class="w-9 h-9 bg-gradient-to-br from-red-500 to-red-700 rounded-lg flex items-center justify-center">
          <span class="material-icons-round text-white text-lg">palette</span>
        </div>
        <div>
          <h1 class="font-display text-base font-bold text-black">KOK4INSTUDIO</h1>
          <p class="text-[10px] text-gray-500">Admin Dashboard</p>
        </div>
        <button v-if="isMobile" @click="sidebarOpen = false" class="ml-auto text-gray-500 hover:text-black p-1">
          <span class="material-icons-round">close</span>
        </button>
      </div>
      
      <!-- Navigation -->
      <nav class="flex-1 py-3 overflow-y-auto px-2">
        <p class="text-[10px] font-bold text-gray-500 uppercase tracking-wider px-3 mb-2">Main Menu</p>
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          @click="isMobile && (sidebarOpen = false)"
          class="flex items-center gap-2 px-3 py-2.5 mx-1.5 rounded-lg text-gray-500 transition-all hover:bg-gray-100 hover:text-black"
          :class="{ 'bg-red-50 text-red-700 font-bold border-l-4 border-red-600 rounded-none ml-0': isActive(item.path)}"
        >
          <span class="material-icons-round text-lg">{{ item.icon }}</span>
          <span class="flex-1 text-xs">{{ item.label }}</span>
        </router-link>
      </nav>
      
      <!-- User Area -->
      <div class="p-4 border-t-2 border-black">
        <div class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-100">
          <div class="w-9 h-9 bg-gradient-to-br from-red-500 to-red-700 rounded-full flex items-center justify-center">
            <span class="material-icons-round text-white text-sm">person</span>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-xs font-bold text-black truncate">Admin</p>
            <p class="text-[10px] text-gray-500 truncate">admin@kok4instudio.com</p>
          </div>
          <button @click="handleLogout" class="text-gray-500 hover:text-red-600 p-1 transition-colors">
            <span class="material-icons-round text-lg">logout</span>
          </button>
        </div>
      </div>
    </aside>
    
    <!-- Main Content -->
    <main class="flex-1 overflow-y-auto">
      <!-- Header -->
      <header class="bg-white border-b-2 border-black px-4 md:px-6 py-3 flex items-center justify-between sticky top-0 z-30">
        <div class="flex items-center gap-3">
          <span class="md:hidden w-9"></span>
          <div>
            <p class="text-[10px] text-gray-500">Welcome back,</p>
            <h2 class="font-display text-sm md:text-base font-bold text-black">{{ currentPageTitle }}</h2>
          </div>
        </div>
        <div class="flex items-center gap-2 md:gap-3">
          <div class="hidden md:flex items-center gap-2 text-[10px] text-gray-600 bg-gray-100 px-3 py-1.5 rounded-lg">
            <span class="material-icons-round text-base text-gray-400">schedule</span>
            {{ new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}}
          </div>
          <button class="p-2 text-gray-500 hover:text-black hover:bg-gray-100 rounded-lg transition-all">
            <span class="material-icons-round">notifications</span>
          </button>
        </div>
      </header>
      
      <!-- Page Content -->
      <div class="p-4 md:p-6">
        <router-view />
      </div>
    </main>
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

const sidebarOpen = ref(false)
const sidebar = ref(null)
const isMobile = ref(window.innerWidth < 768)

const menuItems = [
  { path: '/admin', label: 'Overview', icon: 'space_dashboard' },
  { path: '/admin/products', label: 'Products', icon: 'inventory_2' },
  { path: '/admin/categories', label: 'Categories', icon: 'category' },
  { path: '/admin/inventory', label: 'Inventory', icon: 'inventory' },
  { path: '/admin/pre-orders', label: 'Pre-Orders', icon: 'shopping_cart' },
  { path: '/admin/media', label: 'Media Library', icon: 'perm_media' },
  { path: '/admin/banners', label: 'Banners', icon: 'campaign' },
  { path: '/admin/social', label: 'Social Media', icon: 'share' },
  { path: '/admin/analytics', label: 'Analytics', icon: 'analytics' },
  { path: '/admin/settings', label: 'Settings', icon: 'settings' },
  { path: '/admin/audit-logs', label: 'Audit Logs', icon: 'history' }
]

const currentPageTitle = computed(() => {
  const item = menuItems.find(i => i.path === route.path)
  return item?.label || 'Overview'
})

function isActive(path) {
  return route.path === path
}

async function handleLogout() {
  await authStore.signOut()
  router.push('/admin/login')
}

function handleResize() {
  isMobile.value = window.innerWidth < 768
  if (!isMobile.value) {
    sidebarOpen.value = false
  }
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
  handleResize()

  gsap.fromTo(
    sidebar.value,
    { x: -50, opacity: 0 },
    { x: 0, opacity: 1, duration: 0.5, ease: 'power3.out' }
  )
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})
</script>
