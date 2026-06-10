<template>
  <div class="space-y-5 md:space-y-6">
    <!-- Header Card with Gradient -->
    <div class="bg-white border-2 border-black rounded-xl shadow-sm overflow-hidden">
      <div class="bg-gradient-to-r from-red-600 via-red-500 to-red-700 px-5 py-6 md:px-6 md:py-8">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-3">
          <div>
            <p class="text-red-100 text-xs">Hello, Admin! 👋</p>
            <h2 class="font-display text-xl md:text-2xl font-bold text-white mt-1">Welcome to KOK4INSTUDIO</h2>
            <p class="text-red-100 text-xs mt-2">Here's what's happening today with your fashion store.</p>
          </div>
          <button class="bg-white/20 backdrop-blur-sm hover:bg-white/30 text-white px-3 py-1.5 rounded-lg flex items-center gap-2 transition-all text-sm">
            <span class="material-icons-round text-lg">download</span>
            Export Report
          </button>
        </div>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
      <div v-for="(stat, idx) in statCards" :key="idx" class="bg-white border-2 border-black rounded-lg shadow-sm p-5 hover:shadow-md transition-all duration-300">
        <div class="flex items-start justify-between">
          <div>
            <p class="text-gray-500 text-xs">{{ stat.label }}</p>
            <p class="font-display text-xl md:text-2xl font-bold text-black mt-1">{{ stat.value }}</p>
            <div class="flex items-center gap-2 mt-2">
              <span class="text-[10px] px-2 py-0.5 rounded-full" :class="stat.trendUp ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                <span class="material-icons-round text-sm">{{ stat.trendUp ? 'trending_up' : 'trending_down' }}</span>
              </span>
              <span class="text-gray-500 text-[10px]">{{ stat.sub }}</span>
            </div>
          </div>
          <div class="w-10 h-10 rounded-lg flex items-center justify-center" :class="stat.bgClass">
            <span class="material-icons-round text-xl" :class="stat.iconClass">{{ stat.icon }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-3 md:gap-4">
      <!-- Visitor Chart -->
      <div class="bg-white border-2 border-black rounded-lg shadow-sm lg:col-span-2 overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50 flex items-center justify-between">
          <div>
            <h3 class="font-bold text-black flex items-center gap-2 text-sm">
              <span class="material-icons-round text-red-600">show_chart</span>
              Visitor Trends
            </h3>
            <p class="text-gray-500 text-xs mt-1">Last 7 days performance</p>
          </div>
          <select class="text-xs border-2 border-black rounded-lg px-2 py-1.5 bg-white text-black">
            <option>Last 7 Days</option>
            <option>Last 30 Days</option>
            <option>This Month</option>
          </select>
        </div>
        <div class="p-4">
          <div class="space-y-3">
            <div v-for="(day, i) in visitorData" :key="i" class="flex items-center gap-3">
              <span class="w-10 text-gray-500 text-[10px] md:text-xs">{{ day.label }}</span>
              <div class="flex-1 h-6 bg-gray-100 rounded-lg relative overflow-hidden">
                <div 
                  class="h-full bg-gradient-to-r from-red-500 to-red-600 rounded-lg transition-all duration-700"
                  :style="{ width: `${(day.value / maxVisitors) * 100}%` }"
                ></div>
              </div>
              <span class="w-10 text-black font-bold text-[10px] md:text-xs text-right">{{ day.value }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50 flex items-center justify-between">
          <div>
            <h3 class="font-bold text-black flex items-center gap-2 text-sm">
              <span class="material-icons-round text-red-600">notifications</span>
              Recent Activity
            </h3>
          </div>
          <button class="text-red-600 hover:text-red-700 text-xs font-bold">
            View All
          </button>
        </div>
        <div class="divide-y divide-gray-200 max-h-[350px] overflow-y-auto">
          <div
            v-for="activity in recentActivities"
            :key="activity.id"
            class="p-4"
          >
            <div class="flex items-start gap-3">
              <div class="w-9 h-9 rounded-lg flex items-center justify-center shrink-0" :class="activity.bgClass">
                <span class="material-icons-round text-lg" :class="activity.iconClass">{{ activity.icon }}</span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-black text-xs font-bold">{{ activity.title }}</p>
                <p class="text-gray-500 text-[10px] mt-0.5">{{ activity.description }}</p>
                <p class="text-gray-400 text-[10px] mt-1">{{ activity.time }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Orders & Products -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-3 md:gap-4">
      <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50 flex items-center justify-between">
          <div>
            <h3 class="font-bold text-black flex items-center gap-2 text-sm">
              <span class="material-icons-round text-red-600">shopping_cart</span>
              Recent Pre-Orders
            </h3>
            <p class="text-gray-500 text-xs mt-1">Latest orders from your customers</p>
          </div>
          <router-link to="/admin/pre-orders" class="text-red-600 hover:text-red-700 text-xs font-bold flex items-center gap-1">
            View All
            <span class="material-icons-round text-lg">arrow_forward</span>
          </router-link>
        </div>
        <div class="divide-y divide-gray-200">
          <div
            v-for="order in recentOrders"
            :key="order.id"
            class="p-4"
          >
            <div class="flex items-center justify-between gap-4">
              <div class="min-w-0 flex-1">
                <p class="font-bold text-black truncate text-xs">{{ order.nama_pemesan }}</p>
                <p class="text-xs text-gray-500 truncate mt-0.5">{{ order.produk }} • {{ order.jumlah }} pcs</p>
              </div>
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full" :class="getStatusClass(order.status)">
                {{ order.status }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50 flex items-center justify-between">
          <div>
            <h3 class="font-bold text-black flex items-center gap-2 text-sm">
              <span class="material-icons-round text-red-600">trending_up</span>
              Top Products
            </h3>
            <p class="text-gray-500 text-xs mt-1">Your best selling items</p>
          </div>
          <router-link to="/admin/products" class="text-red-600 hover:text-red-700 text-xs font-bold flex items-center gap-1">
            View All
            <span class="material-icons-round text-lg">arrow_forward</span>
          </router-link>
        </div>
        <div class="divide-y divide-gray-200">
          <div
            v-for="(product, i) in topProducts"
            :key="product.id"
            class="p-4"
          >
            <div class="flex items-center gap-3">
              <span class="w-9 h-9 bg-gray-100 rounded-lg flex items-center justify-center text-black font-bold shrink-0 text-sm">
                {{ i + 1 }}
              </span>
              <div class="flex-1 min-w-0">
                <p class="font-bold text-black truncate text-xs">{{ product.name }}</p>
                <p class="text-[10px] text-gray-500 mt-0.5">{{ product.view_count || 0 }} views</p>
              </div>
              <span class="text-black font-bold text-xs">
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
    sub: `Published: ${stats.value.publishedProducts}`,
    trendUp: true,
    icon: 'inventory_2',
    bgClass: 'bg-red-100',
    iconClass: 'text-red-700'
  },
  {
    label: 'Active Pre-Orders',
    value: stats.value.preOrders,
    sub: `Today: ${stats.value.todayOrders} new`,
    trendUp: true,
    icon: 'shopping_cart',
    bgClass: 'bg-red-100',
    iconClass: 'text-red-700'
  },
  {
    label: 'Total Views',
    value: stats.value.totalViews.toLocaleString(),
    sub: `${stats.value.todayViews.toLocaleString()} today`,
    trendUp: true,
    icon: 'visibility',
    bgClass: 'bg-red-100',
    iconClass: 'text-red-700'
  },
  {
    label: 'Revenue Today',
    value: `Rp ${(0).toLocaleString()}`,
    sub: 'Waiting for sales',
    trendUp: true,
    icon: 'payments',
    bgClass: 'bg-red-100',
    iconClass: 'text-red-700'
  }
])

const recentOrders = ref([])
const topProducts = ref([])
const recentActivities = ref([])

const visitorData = ref([
  { label: 'Mon', value: 156 },
  { label: 'Tue', value: 234 },
  { label: 'Wed', value: 189 },
  { label: 'Thu', value: 312 },
  { label: 'Fri', value: 278 },
  { label: 'Sat', value: 421 },
  { label: 'Sun', value: 367 }
])

const maxVisitors = computed(() => Math.max(...visitorData.value.map(d => d.value), 100))

onMounted(async () => {
  await loadStats()
  await loadRecentOrders()
  await loadTopProducts()
  await loadActivities()
})

async function loadStats() {
  const { count: productsCount } = await supabase.from('products').select('*', { count: 'exact', head: true })
  const { count: publishedCount } = await supabase.from('products').select('*', { count: 'exact', head: true }).eq('status', 'published')
  const { count: preOrdersCount } = await supabase.from('pre-orders').select('*', { count: 'exact', head: true }).not('status', 'in', '("selesai","dibatalkan")')
  
  stats.value = {
    products: productsCount || 0,
    publishedProducts: publishedCount || 0,
    preOrders: preOrdersCount || 0,
    todayOrders: 0,
    totalViews: 1250,
    todayViews: 85,
    lowStock: 0,
    revenue: 0,
    conversion: 0
  }
}

async function loadRecentOrders() {
  const { data } = await supabase
    .from('pre-orders')
    .select('*')
    .order('created_at', { ascending: false })
    .limit(5)
  
  recentOrders.value = data || []
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
      bgClass: 'bg-red-100',
      iconClass: 'text-red-700'
    },
    {
      id: 2,
      icon: 'check_circle',
      title: 'Product Published',
      description: 'Jacket Denim is now available',
      time: '1 hour ago',
      bgClass: 'bg-red-100',
      iconClass: 'text-red-700'
    },
    {
      id: 3,
      icon: 'inventory',
      title: 'Stock Updated',
      description: 'Hoodie Grey restocked (+50)',
      time: '3 hours ago',
      bgClass: 'bg-red-100',
      iconClass: 'text-red-700'
    }
  ]
}

function getStatusClass(status) {
  const classes = {
    baru: 'bg-gray-100 text-gray-700 border border-gray-300',
    dikonfirmasi: 'bg-blue-100 text-blue-700 border border-blue-300',
    diproses: 'bg-yellow-100 text-yellow-700 border border-yellow-300',
    dikirim: 'bg-purple-100 text-purple-700 border border-purple-300',
    selesai: 'bg-green-100 text-green-700 border border-green-300',
    dibatalkan: 'bg-red-100 text-red-700 border border-red-300'
  }
  return classes[status] || 'bg-gray-100 text-gray-700 border border-gray-300'
}
</script>
