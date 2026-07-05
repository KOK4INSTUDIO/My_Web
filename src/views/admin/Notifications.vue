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
        <div v-for="notification in allNotifications" :key="notification.id" @click="openDetail(notification)" class="p-5 hover:bg-gray-50 transition-colors cursor-pointer" :class="{'bg-purple-50': !notification.read}">
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

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <div class="bg-white rounded-3xl shadow-2xl max-w-lg w-full max-h-[80vh] overflow-hidden">
        <div class="bg-gradient-to-r from-purple-600 via-purple-500 to-purple-700 px-6 py-6 flex items-center justify-between">
          <h3 class="font-display text-xl font-bold text-white">Detail Notifikasi</h3>
          <button @click="closeDetailModal" class="p-2 hover:bg-white/20 rounded-xl transition-colors">
            <span class="material-icons-round text-white text-2xl">close</span>
          </button>
        </div>
        <div v-if="selectedNotification" class="p-6">
          <div class="flex items-start gap-4 mb-6">
            <div class="w-16 h-16 rounded-2xl flex items-center justify-center shrink-0 shadow-md" :class="selectedNotification.bgClass">
              <span class="material-icons-round text-3xl" :class="selectedNotification.iconClass">{{ selectedNotification.icon }}</span>
            </div>
            <div class="flex-1">
              <h4 class="font-bold text-gray-800 text-lg">{{ selectedNotification.title }}</h4>
              <p class="text-gray-500 text-sm mt-1 flex items-center gap-1">
                <span class="material-icons-round text-sm">schedule</span>
                {{ selectedNotification.time }}
              </p>
            </div>
          </div>
          <div class="bg-gray-50 rounded-2xl p-4 mb-6">
            <h5 class="font-semibold text-gray-800 text-sm mb-2 flex items-center gap-2">
              <span class="material-icons-round text-purple-600 text-lg">description</span>
              Deskripsi
            </h5>
            <p class="text-gray-600 text-sm">{{ selectedNotification.description }}</p>
          </div>
          <div v-if="selectedNotification.contact" class="bg-emerald-50 rounded-2xl p-4 mb-6">
            <h5 class="font-semibold text-emerald-800 text-sm mb-2 flex items-center gap-2">
              <span class="material-icons-round text-emerald-600 text-lg">contact_mail</span>
              Detail Pengirim
            </h5>
            <div class="space-y-2">
              <p class="text-emerald-700 text-sm"><span class="font-medium">Nama:</span> {{ selectedNotification.contact.name }}</p>
              <p class="text-emerald-700 text-sm"><span class="font-medium">Email:</span> {{ selectedNotification.contact.email }}</p>
              <p class="text-emerald-700 text-sm"><span class="font-medium">Subjek:</span> {{ selectedNotification.contact.subject }}</p>
              <p class="text-emerald-700 text-sm"><span class="font-medium">Pesan Lengkap:</span> {{ selectedNotification.contact.message }}</p>
            </div>
          </div>
          <div class="flex gap-3">
            <button v-if="!selectedNotification.read" @click="markAsRead" class="flex-1 bg-gradient-to-r from-purple-500 to-purple-600 text-white hover:from-purple-600 hover:to-purple-700 px-5 py-3 rounded-xl flex items-center justify-center gap-2 transition-all font-semibold shadow-lg hover:shadow-xl">
              <span class="material-icons-round text-xl">done</span>
              Tandai Dibaca
            </button>
            <button @click="closeDetailModal" class="flex-1 bg-gray-100 text-gray-700 hover:bg-gray-200 px-5 py-3 rounded-xl flex items-center justify-center gap-2 transition-all font-semibold">
              Tutup
            </button>
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

// Modal state
const showDetailModal = ref(false)
const selectedNotification = ref(null)

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
    read: false,
    contact: msg
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

function openDetail(notification) {
  selectedNotification.value = notification
  showDetailModal.value = true
}

function closeDetailModal() {
  showDetailModal.value = false
  selectedNotification.value = null
}

function markAsRead() {
  if (selectedNotification.value) {
    // Mark as read in recent activities if it's an activity
    const activityIndex = recentActivities.value.findIndex(act => act.id === selectedNotification.value.id)
    if (activityIndex !== -1) {
      recentActivities.value[activityIndex].read = true
    }
    selectedNotification.value.read = true
    closeDetailModal()
  }
}

onMounted(() => {
  // Initialize
})
</script>
