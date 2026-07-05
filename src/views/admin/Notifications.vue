<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="bg-white rounded-3xl shadow-md overflow-hidden border-0">
      <div class="bg-gradient-to-r from-purple-600 via-purple-500 to-purple-700 px-6 py-8 md:px-8 md:py-10">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div>
            <p class="text-purple-100 text-sm">Notifikasi Sistem</p>
            <h2 class="font-display text-2xl md:text-3xl font-bold text-white mt-1">Notifikasi</h2>
            <p class="text-purple-100 text-sm mt-2">Semua notifikasi dan aktivitas terbaru</p>
          </div>
          <div class="flex items-center gap-3">
            <button @click="markAllAsRead" class="bg-white text-purple-700 hover:bg-purple-50 px-5 py-2.5 rounded-xl flex items-center gap-2 transition-all font-semibold shadow-lg hover:shadow-xl">
              <span class="material-icons-round text-xl">done_all</span>
              Tandai Semua Dibaca
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications List -->
    <div class="bg-white rounded-3xl shadow-md overflow-hidden border-0">
      <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gradient-to-r from-gray-50 to-white">
        <h3 class="font-bold text-gray-800 text-lg flex items-center gap-2">
          <span class="material-icons-round text-purple-600">notifications</span>
          Daftar Notifikasi
        </h3>
        <span class="text-sm text-gray-500">{{ allNotifications.length }} notifikasi</span>
      </div>
      <div class="divide-y divide-gray-100 max-h-[70vh] overflow-y-auto">
        <div v-for="notification in allNotifications" :key="notification.id" class="p-5 hover:bg-gray-50 transition-colors" :class="{'bg-purple-50': !notification.read}">
          <div class="flex items-start gap-4">
            <div class="w-12 h-12 rounded-2xl flex items-center justify-center shrink-0 shadow-md" :class="notification.bgClass">
              <span class="material-icons-round text-2xl" :class="notification.iconClass">{{ notification.icon }}</span>
            </div>
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between mb-1">
                <p class="text-gray-800 text-sm font-bold">{{ notification.title }}</p>
                <span v-if="!notification.read" class="w-2.5 h-2.5 bg-purple-500 rounded-full"></span>
              </div>
              <p class="text-gray-600 text-xs mb-2">{{ notification.description }}</p>
              <p class="text-gray-400 text-xs flex items-center gap-1">
                <span class="material-icons-round text-sm">schedule</span>
                {{ notification.time }}
              </p>
            </div>
          </div>
        </div>
        <div v-if="allNotifications.length === 0" class="p-12 text-center">
          <div class="flex flex-col items-center gap-3">
            <span class="material-icons-round text-6xl text-gray-300">notifications_none</span>
            <p class="text-gray-500">Belum ada notifikasi</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useContactStore } from '@/stores/contact'

const contactStore = useContactStore()

// Recent activities data
const recentActivities = ref([
  {
    id: 1,
    icon: 'shopping_cart_checkout',
    title: 'New Pre-Order Received',
    description: 'John Doe ordered T-Shirt Black - XL',
    time: '2 menit yang lalu',
    bgClass: 'bg-green-100',
    iconClass: 'text-green-700',
    read: false
  },
  {
    id: 2,
    icon: 'check_circle',
    title: 'Product Published',
    description: 'Jacket Denim is now available',
    time: '1 jam yang lalu',
    bgClass: 'bg-primary-100',
    iconClass: 'text-primary-700',
    read: false
  },
  {
    id: 3,
    icon: 'inventory',
    title: 'Stock Updated',
    description: 'Hoodie Grey restocked (+50)',
    time: '3 jam yang lalu',
    bgClass: 'bg-blue-100',
    iconClass: 'text-blue-700',
    read: true
  }
])

// Combine contact messages and recent activities
const allNotifications = computed(() => {
  const contactNotifications = contactStore.messages.map(msg => ({
    id: `contact-${msg.id}`,
    icon: 'mail',
    title: `Pesan dari ${msg.name}`,
    description: `${msg.subject}: ${msg.message.substring(0, 50)}${msg.message.length > 50 ? '...' : ''}`,
    time: new Date(msg.createdAt).toLocaleString('id-ID'),
    bgClass: 'bg-emerald-100',
    iconClass: 'text-emerald-700',
    read: false
  }))
  
  return [...contactNotifications, ...recentActivities.value].sort((a, b) => {
    // Sort by read status (unread first) and then by time
    if (a.read !== b.read) return a.read ? 1 : -1
    return 0
  })
})

function markAllAsRead() {
  recentActivities.value = recentActivities.value.map(act => ({ ...act, read: true }))
  // For contact messages, we don't track read status, so just leave as is
}

onMounted(() => {
  // Initialize
})
</script>
