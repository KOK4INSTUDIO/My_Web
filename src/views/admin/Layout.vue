<template>
  <div class="flex h-screen bg-gradient-to-b from-white to-primary-50">
    <!-- Sidebar Toggle (All Screens) -->
    <button
      @click="sidebarOpen = !sidebarOpen"
      class="fixed top-4 left-4 z-50 bg-white border border-primary-200 text-accent-dark p-3 rounded-xl shadow-soft hover:bg-primary-50 transition-all"
    >
      <span class="material-icons-round text-xl">{{ sidebarOpen ? 'menu_open' : 'menu' }}</span>
    </button>

    <!-- Sidebar Overlay (mobile) -->
    <div
      v-if="sidebarOpen && isMobile"
      @click="sidebarOpen = false"
      class="fixed inset-0 bg-black/30 backdrop-blur-sm z-40"
    ></div>

    <!-- Sidebar -->
    <aside
      ref="sidebar"
      class="fixed md:relative z-50 bg-white border-r border-primary-100 flex flex-col h-full transition-all duration-300 shadow-sm"
      :class="[
        sidebarOpen ? 'w-64' : 'w-20',
        isMobile ? (sidebarOpen ? 'translate-x-0' : '-translate-x-full') : ''
      ]"
    >
      <!-- Logo Area -->
      <div class="p-5 border-b border-primary-100 flex items-center gap-3">
        <img
          src="/asset/logo.png"
          alt="KOK4INSTUDIO"
          class="h-8 object-contain"
        />
        <div v-if="sidebarOpen">
          <h1 class="font-display text-base font-bold text-accent-dark">KOK4INSTUDIO™</h1>
          <p class="text-[10px] text-accent-gray">Admin</p>
        </div>
        <button v-if="isMobile && sidebarOpen" @click="sidebarOpen = false" class="ml-auto text-accent-gray hover:text-primary-600 p-1">
          <span class="material-icons-round">close</span>
        </button>
      </div>
      
      <!-- Navigation -->
      <nav class="flex-1 py-4 overflow-y-auto px-3">
        <p v-if="sidebarOpen" class="text-[10px] font-bold text-primary-600 uppercase tracking-wider px-3 mb-3">Main Menu</p>
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          @click="isMobile && (sidebarOpen = false)"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-accent-gray transition-all hover:bg-primary-50 hover:text-primary-700 mb-0.5"
          :class="[
            isActive(item.path) ? 'bg-primary-50 text-primary-700 font-medium border border-primary-100' : '',
            !sidebarOpen ? 'justify-center' : ''
          ]"
        >
          <span class="material-icons-round text-xl">{{ item.icon }}</span>
          <span v-if="sidebarOpen" class="flex-1 text-sm">{{ item.label }}</span>
        </router-link>
      </nav>
      
      <!-- User Area -->
      <div class="p-4 border-t border-primary-100 bg-primary-50/50">
        <div class="flex items-center gap-3" :class="!sidebarOpen ? 'justify-center' : ''">
          <div class="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-700 rounded-full flex items-center justify-center shadow-red">
            <span class="material-icons-round text-white text-sm">person</span>
          </div>
          <div v-if="sidebarOpen" class="flex-1 min-w-0">
            <p class="text-sm font-medium text-accent-dark truncate">Admin</p>
            <p class="text-xs text-accent-gray truncate">admin@kok4instudio.com</p>
          </div>
          <button v-if="sidebarOpen" @click="handleLogout" class="text-accent-gray hover:text-primary-600 p-1.5 transition-colors">
            <span class="material-icons-round text-xl">logout</span>
          </button>
        </div>
      </div>
    </aside>
    
    <!-- Main Content -->
    <main class="flex-1 overflow-y-auto">
      <!-- Header -->
      <header class="bg-white/80 backdrop-blur-md border-b border-primary-100 px-4 md:px-8 py-4 flex items-center justify-between sticky top-0 z-30">
        <div class="flex items-center gap-3">
          <span class="w-12 md:w-16"></span>
          <h2 class="font-display text-lg md:text-xl font-bold text-accent-dark">{{ currentPageTitle }}</h2>
        </div>
        <div class="flex items-center gap-3">
          <div class="text-sm text-accent-gray hidden md:flex items-center gap-2">
            <span class="material-icons-round text-primary-600 text-lg">schedule</span>
            {{ new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}}
          </div>
        </div>
      </header>
      
      <!-- Page Content -->
      <div class="p-4 md:p-8">
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

const sidebarOpen = ref(true)
const sidebar = ref(null)
const isMobile = ref(window.innerWidth < 768)

const menuItems = [
  { path: '/admin', label: 'Overview', icon: 'space_dashboard' },
  { path: '/admin/products', label: 'Products', icon: 'inventory_2' },
  { path: '/admin/categories', label: 'Categories', icon: 'category' },
  { path: '/admin/inventory', label: 'Inventory', icon: 'inventory' },
  { path: '/admin/analytics', label: 'Analytics', icon: 'analytics' },
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
  router.push('/')
}

function handleResize() {
  isMobile.value = window.innerWidth < 768
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
