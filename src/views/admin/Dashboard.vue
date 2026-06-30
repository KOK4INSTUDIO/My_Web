<template>
  <div class="space-y-6 md:space-y-8">
    <!-- Header Card with Gradient -->
    <div class="bg-white rounded-3xl shadow-lg overflow-hidden border-0">
      <div class="bg-gradient-to-br from-primary-600 via-primary-500 to-primary-700 px-6 py-8 md:px-10 md:py-12">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div>
            <div class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-sm px-3 py-1.5 rounded-full mb-3">
              <span class="material-icons-round text-white text-sm">waving_hand</span>
              <span class="text-white/90 text-sm font-medium">Hello, Admin!</span>
            </div>
            <h2 class="font-display text-2xl md:text-4xl font-bold text-white">Welcome back! 👋</h2>
            <p class="text-white/80 text-sm md:text-base mt-2">Here's your fashion store dashboard today.</p>
          </div>
          <button class="bg-white text-primary-600 hover:bg-primary-50 px-5 py-3 rounded-2xl flex items-center gap-2 transition-all font-semibold shadow-lg hover:shadow-xl">
            <span class="material-icons-round text-xl">download</span>
            Export Report
          </button>
        </div>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
      <div v-for="(stat, idx) in statCards" :key="idx" class="bg-white rounded-3xl shadow-md hover:shadow-xl transition-all duration-500 p-6 border-0 group hover:-translate-y-1">
        <div class="flex items-start justify-between">
          <div>
            <p class="text-gray-500 text-sm font-medium mb-1">{{ stat.label }}</p>
            <p class="font-display text-3xl md:text-4xl font-bold text-gray-800 mt-1 group-hover:text-primary-600 transition-colors">{{ stat.value }}</p>
            <div class="flex items-center gap-2 mt-3">
              <span class="text-xs px-2.5 py-1 rounded-full flex items-center gap-1 font-semibold" :class="stat.trendUp ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                <span class="material-icons-round text-sm">{{ stat.trendUp ? 'trending_up' : 'trending_down' }}</span>
                {{ stat.sub }}
              </span>
            </div>
          </div>
          <div class="w-14 h-14 rounded-2xl flex items-center justify-center shadow-lg" :class="stat.bgClass">
            <span class="material-icons-round text-3xl" :class="stat.iconClass">{{ stat.icon }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="bg-white rounded-3xl shadow-md p-6 border-0">
      <h3 class="font-bold text-gray-800 text-lg mb-5 flex items-center gap-2">
        <span class="material-icons-round text-primary-600 text-2xl">lightbulb</span>
        Quick Actions
      </h3>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <router-link to="/admin/products" class="flex flex-col items-center gap-3 p-5 bg-gradient-to-br from-primary-50 to-primary-100 rounded-2xl hover:shadow-lg transition-all hover:-translate-y-1 border border-primary-100">
          <div class="w-12 h-12 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl flex items-center justify-center shadow-md">
            <span class="material-icons-round text-white text-2xl">add_circle</span>
          </div>
          <span class="text-sm font-bold text-gray-700">Add Product</span>
        </router-link>
        <router-link to="/admin/pre-orders" class="flex flex-col items-center gap-3 p-5 bg-gradient-to-br from-teal-50 to-teal-100 rounded-2xl hover:shadow-lg transition-all hover:-translate-y-1 border border-teal-100">
          <div class="w-12 h-12 bg-gradient-to-br from-teal-500 to-teal-600 rounded-xl flex items-center justify-center shadow-md">
            <span class="material-icons-round text-white text-2xl">shopping_cart</span>
          </div>
          <span class="text-sm font-bold text-gray-700">Orders</span>
        </router-link>
        <router-link to="/admin/inventory" class="flex flex-col items-center gap-3 p-5 bg-gradient-to-br from-blue-50 to-blue-100 rounded-2xl hover:shadow-lg transition-all hover:-translate-y-1 border border-blue-100">
          <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl flex items-center justify-center shadow-md">
            <span class="material-icons-round text-white text-2xl">inventory</span>
          </div>
          <span class="text-sm font-bold text-gray-700">Inventory</span>
        </router-link>
        <router-link to="/admin/banners" class="flex flex-col items-center gap-3 p-5 bg-gradient-to-br from-purple-50 to-purple-100 rounded-2xl hover:shadow-lg transition-all hover:-translate-y-1 border border-purple-100">
          <div class="w-12 h-12 bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl flex items-center justify-center shadow-md">
            <span class="material-icons-round text-white text-2xl">image</span>
          </div>
          <span class="text-sm font-bold text-gray-700">Banners</span>
        </router-link>
      </div>
    </div>

    <!-- Low Stock Alert -->
    <div v-if="lowStockProducts.length > 0" class="bg-gradient-to-r from-amber-50 to-orange-50 border-0 rounded-3xl shadow-md p-6">
      <div class="flex items-start gap-4">
        <div class="w-14 h-14 bg-gradient-to-br from-amber-400 to-orange-500 rounded-2xl flex items-center justify-center shadow-lg">
          <span class="material-icons-round text-white text-3xl">warning</span>
        </div>
        <div class="flex-1">
          <h3 class="font-bold text-gray-800 text-lg">Low Stock Alert!</h3>
          <p class="text-sm text-orange-700 mt-1">You have {{ lowStockProducts.length }} product(s) that need restocking soon</p>
          <div class="flex flex-wrap gap-2 mt-4">
            <span v-for="product in lowStockProducts" :key="product.id" class="px-4 py-2 bg-white border border-amber-200 rounded-xl text-sm font-medium text-gray-700 shadow-sm">
              <span class="material-icons-round text-sm text-amber-500 mr-1">inventory_2</span>
              {{ product.name }} - {{ product.stock }} pcs
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Visitor Chart -->
      <div class="bg-white rounded-3xl shadow-md lg:col-span-2 border-0 overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gradient-to-r from-gray-50 to-white">
          <div>
            <h3 class="font-bold text-gray-800 text-lg flex items-center gap-2">
              <span class="material-icons-round text-primary-600 text-2xl">show_chart</span>
              Visitor Trends
            </h3>
            <p class="text-gray-500 text-sm mt-1">Last 7 days performance</p>
          </div>
          <select class="text-sm border border-gray-200 rounded-xl px-4 py-2 bg-white text-gray-700 font-medium">
            <option>Last 7 Days</option>
            <option>Last 30 Days</option>
            <option>This Month</option>
          </select>
        </div>
        <div class="p-6">
          <div class="space-y-4">
            <div v-for="(day, i) in visitorData" :key="i" class="flex items-center gap-4">
              <span class="w-12 text-gray-500 text-xs md:text-sm font-semibold">{{ day.label }}</span>
              <div class="flex-1 h-12 bg-gray-100 rounded-2xl relative overflow-hidden">
                <div 
                  class="h-full bg-gradient-to-r from-primary-400 via-primary-500 to-primary-600 rounded-2xl transition-all duration-1000"
                  :style="{ width: `${(day.value / maxVisitors) * 100}%` }"
                >
                  <div class="absolute inset-0 bg-white/30 animate-pulse"></div>
                </div>
              </div>
              <span class="w-16 text-gray-800 font-bold text-xs md:text-sm text-right">{{ day.value }} visits</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white rounded-3xl shadow-md border-0 overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gradient-to-r from-gray-50 to-white">
          <div>
            <h3 class="font-bold text-gray-800 text-lg flex items-center gap-2">
              <span class="material-icons-round text-primary-600 text-2xl">notifications</span>
              Recent Activity
            </h3>
          </div>
          <button class="text-primary-600 hover:text-primary-700 text-sm font-semibold">
            View All
          </button>
        </div>
        <div class="divide-y divide-gray-100 max-h-[420px] overflow-y-auto">
          <div
            v-for="activity in recentActivities"
            :key="activity.id"
            class="p-5 hover:bg-gray-50 transition-colors"
          >
            <div class="flex items-start gap-4">
              <div class="w-12 h-12 rounded-2xl flex items-center justify-center shrink-0 shadow-md" :class="activity.bgClass">
                <span class="material-icons-round text-2xl" :class="activity.iconClass">{{ activity.icon }}</span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-gray-800 text-sm font-bold">{{ activity.title }}</p>
                <p class="text-gray-500 text-xs mt-1">{{ activity.description }}</p>
                <p class="text-gray-400 text-xs mt-2 flex items-center gap-1">
                  <span class="material-icons-round text-sm">schedule</span>
                  {{ activity.time }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Top Products -->
    <div class="grid grid-cols-1 lg:grid-cols-1 gap-6">
      <div class="bg-white rounded-3xl shadow-md border-0 overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gradient-to-r from-gray-50 to-white">
          <div>
            <h3 class="font-bold text-gray-800 text-lg flex items-center gap-2">
              <span class="material-icons-round text-primary-600 text-2xl">trending_up</span>
              Top Products
            </h3>
            <p class="text-gray-500 text-sm mt-1">Your most viewed items</p>
          </div>
          <router-link to="/admin/products" class="text-primary-600 hover:text-primary-700 text-sm font-semibold flex items-center gap-1">
            View All
            <span class="material-icons-round text-lg">arrow_forward</span>
          </router-link>
        </div>
        <div class="divide-y divide-gray-100">
          <div
            v-for="(product, i) in topProducts"
            :key="product.id"
            class="p-5 hover:bg-gray-50 transition-colors"
          >
            <div class="flex items-center gap-5">
              <span class="w-12 h-12 bg-gradient-to-br from-primary-100 to-primary-200 rounded-2xl flex items-center justify-center text-primary-700 font-bold shrink-0 text-lg">
                {{ i + 1 }}
              </span>
              <div class="flex-1 min-w-0">
                <p class="font-bold text-gray-800 truncate">{{ product.name }}</p>
                <p class="text-xs text-gray-500 mt-1 flex items-center gap-1">
                  <span class="material-icons-round text-sm">visibility</span>
                  {{ product.view_count || 0 }} views
                </p>
              </div>
              <span class="text-gray-800 font-bold text-lg">
                Rp {{ (product.promo_price || product.price)?.toLocaleString() }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const stats = ref({
  products: 0,
  publishedProducts: 0,
  preOrders: 0,
  todayOrders: 0,
  totalViews: 0,
  todayViews: 0,
  lowStock: 0,
  revenue: 0,
  conversion: 0
})

const statCards = computed(() => [
  {
    label: 'Total Products',
    value: stats.value.products,
    sub: `${stats.value.publishedProducts} published`,
    trendUp: true,
    icon: 'inventory_2',
    bgClass: 'bg-primary-100',
    iconClass: 'text-primary-700'
  },
  {
    label: 'Active Pre-Orders',
    value: stats.value.preOrders,
    sub: `${stats.value.todayOrders} today`,
    trendUp: true,
    icon: 'shopping_cart',
    bgClass: 'bg-teal-100',
    iconClass: 'text-teal-700'
  },
  {
    label: 'Total Views',
    value: stats.value.totalViews.toLocaleString(),
    sub: `${stats.value.todayViews.toLocaleString()} today`,
    trendUp: true,
    icon: 'visibility',
    bgClass: 'bg-blue-100',
    iconClass: 'text-blue-700'
  },
  {
    label: 'Low Stock',
    value: stats.value.lowStock,
    sub: 'Need restock',
    trendUp: false,
    icon: 'inventory',
    bgClass: 'bg-amber-100',
    iconClass: 'text-amber-700'
  }
])

const topProducts = ref([])
const lowStockProducts = ref([])
const recentActivities = ref([])

const visitorData = ref([
  { label: 'Mon', value: 0 },
  { label: 'Tue', value: 0 },
  { label: 'Wed', value: 0 },
  { label: 'Thu', value: 0 },
  { label: 'Fri', value: 0 },
  { label: 'Sat', value: 0 },
  { label: 'Sun', value: 0 }
])

const maxVisitors = computed(() => Math.max(...visitorData.value.map(d => d.value), 100))

onMounted(async () => {
  await loadStats()
  await loadTopProducts()
  await loadLowStockProducts()
  await loadActivities()
  await loadVisitorData()
})

async function loadVisitorData() {
  // Get last 7 days of visitors
  const sevenDaysAgo = new Date()
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)

  const { data, error } = await supabase
    .from('visitors')
    .select('visit_date')
    .gte('visit_date', sevenDaysAgo.toISOString())

  if (error) {
    console.log('Error loading visitor data:', error)
    return
  }

  // Reset visitor data
  visitorData.value = [
    { label: 'Mon', value: 0 },
    { label: 'Tue', value: 0 },
    { label: 'Wed', value: 0 },
    { label: 'Thu', value: 0 },
    { label: 'Fri', value: 0 },
    { label: 'Sat', value: 0 },
    { label: 'Sun', value: 0 }
  ]

  // Group visits by day of week (0 = Sunday, 1 = Monday, ...)
  const dayMap = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  data?.forEach(visit => {
    const date = new Date(visit.visit_date)
    const dayName = dayMap[date.getDay()]
    const dayIndex = visitorData.value.findIndex(d => d.label === dayName)
    if (dayIndex !== -1) {
      visitorData.value[dayIndex].value++
    }
  })
}

async function loadStats() {
  const { count: productsCount } = await supabase.from('products').select('*', { count: 'exact', head: true })
  const { count: publishedCount } = await supabase.from('products').select('*', { count: 'exact', head: true }).eq('status', 'published')
  const { count: preOrdersCount } = await supabase.from('pre-orders').select('*', { count: 'exact', head: true }).not('status', 'in', '("selesai","dibatalkan")')
  const { count: lowStockCount } = await supabase.from('products').select('*', { count: 'exact', head: true }).lt('stock', 10)
  
  stats.value = {
    products: productsCount || 0,
    publishedProducts: publishedCount || 0,
    preOrders: preOrdersCount || 0,
    todayOrders: 0,
    totalViews: 1250,
    todayViews: 85,
    lowStock: lowStockCount || 0,
    revenue: 0,
    conversion: 0
  }
}

async function loadLowStockProducts() {
  const { data } = await supabase
    .from('products')
    .select('*')
    .lt('stock', 10)
    .limit(5)
  
  lowStockProducts.value = data || []
}



async function loadTopProducts() {
  const { data } = await supabase
    .from('products')
    .select('*')
    .order('view_count', { ascending: false, nullsFirst: false })
    .limit(5)
  
  topProducts.value = data || []
}

async function loadActivities() {
  recentActivities.value = [
    {
      id: 1,
      icon: 'shopping_cart_checkout',
      title: 'New Pre-Order Received',
      description: 'John Doe ordered T-Shirt Black - XL',
      time: '2 minutes ago',
      bgClass: 'bg-green-100',
      iconClass: 'text-green-700'
    },
    {
      id: 2,
      icon: 'check_circle',
      title: 'Product Published',
      description: 'Jacket Denim is now available',
      time: '1 hour ago',
      bgClass: 'bg-primary-100',
      iconClass: 'text-primary-700'
    },
    {
      id: 3,
      icon: 'inventory',
      title: 'Stock Updated',
      description: 'Hoodie Grey restocked (+50)',
      time: '3 hours ago',
      bgClass: 'bg-blue-100',
      iconClass: 'text-blue-700'
    }
  ]
}

function getStatusClass(status) {
  const classes = {
    pending: 'bg-amber-100 text-amber-700',
    confirmed: 'bg-blue-100 text-blue-700',
    processing: 'bg-purple-100 text-purple-700',
    shipped: 'bg-teal-100 text-teal-700',
    completed: 'bg-green-100 text-green-700',
    cancelled: 'bg-red-100 text-red-700'
  }
  return classes[status] || 'bg-primary-100 text-primary-700'
}
</script>
