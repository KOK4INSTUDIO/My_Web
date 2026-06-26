<template>
  <div class="space-y-6 md:space-y-8">
    <!-- Header Card with Gradient -->
    <div class="bg-white border border-primary-200 rounded-2xl shadow-sm overflow-hidden">
      <div class="bg-gradient-to-r from-primary-600 via-primary-500 to-primary-700 px-6 py-8 md:px-8 md:py-10">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div>
            <p class="text-primary-100 text-sm">Hello, Admin!</p>
            <h2 class="font-display text-2xl md:text-3xl font-bold text-white mt-1">Welcome to KOK4INSTUDIO™</h2>
            <p class="text-primary-100 text-sm mt-2">Here's what's happening today with your fashion store.</p>
          </div>
          <button class="bg-white/20 backdrop-blur-sm hover:bg-white/30 text-white px-4 py-2 rounded-lg flex items-center gap-2 transition-all">
            <span class="material-icons-round text-lg">download</span>
            Export Report
          </button>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="bg-white border border-primary-200 rounded-2xl shadow-sm p-6">
      <h3 class="font-semibold text-accent-dark mb-4">Quick Actions</h3>
      <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
        <router-link to="/admin/products" class="flex flex-col items-center gap-2 p-4 bg-primary-50 border border-primary-100 rounded-xl hover:bg-primary-100 transition-all">
          <span class="material-icons-round text-primary-600 text-2xl">add_circle</span>
          <span class="text-sm font-medium text-accent-dark">Add Product</span>
        </router-link>
        <router-link to="/admin/pre-orders" class="flex flex-col items-center gap-2 p-4 bg-teal-50 border border-teal-100 rounded-xl hover:bg-teal-100 transition-all">
          <span class="material-icons-round text-teal-600 text-2xl">shopping_cart</span>
          <span class="text-sm font-medium text-accent-dark">Orders</span>
        </router-link>
        <router-link to="/admin/categories" class="flex flex-col items-center gap-2 p-4 bg-blue-50 border border-blue-100 rounded-xl hover:bg-blue-100 transition-all">
          <span class="material-icons-round text-blue-600 text-2xl">category</span>
          <span class="text-sm font-medium text-accent-dark">Categories</span>
        </router-link>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
      <div v-for="(stat, idx) in statCards" :key="idx" class="bg-white border border-primary-200 rounded-2xl shadow-sm p-6 hover:shadow-md transition-all duration-300">
        <div class="flex items-start justify-between">
          <div>
            <p class="text-accent-gray text-sm">{{ stat.label }}</p>
            <p class="font-display text-2xl md:text-3xl font-bold text-accent-dark mt-1">{{ stat.value }}</p>
            <div class="flex items-center gap-2 mt-2">
              <span class="text-xs px-2 py-0.5 rounded-full flex items-center gap-1" :class="stat.trendUp ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                <span class="material-icons-round text-sm">{{ stat.trendUp ? 'trending_up' : 'trending_down' }}</span>
                {{ stat.sub }}
              </span>
            </div>
          </div>
          <div class="w-12 h-12 rounded-xl flex items-center justify-center" :class="stat.bgClass">
            <span class="material-icons-round text-2xl" :class="stat.iconClass">{{ stat.icon }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Low Stock Alert -->
    <div v-if="lowStockProducts.length > 0" class="bg-amber-50 border border-amber-200 rounded-2xl shadow-sm p-6">
      <div class="flex items-start gap-4">
        <div class="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center">
          <span class="material-icons-round text-amber-600 text-2xl">warning</span>
        </div>
        <div class="flex-1">
          <h3 class="font-semibold text-accent-dark">Low Stock Alert</h3>
          <p class="text-sm text-amber-700 mt-1">You have {{ lowStockProducts.length }} product(s) with low stock</p>
          <div class="flex flex-wrap gap-2 mt-3">
            <span v-for="product in lowStockProducts" :key="product.id" class="px-3 py-1 bg-white border border-amber-200 rounded-full text-sm">
              {{ product.name }} - {{ product.stock }} pcs
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-6">
      <!-- Visitor Chart -->
      <div class="bg-white border border-primary-200 rounded-2xl shadow-sm lg:col-span-2">
        <div class="p-4 md:p-6 border-b border-primary-100 flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-accent-dark flex items-center gap-2">
              <span class="material-icons-round text-primary-600">show_chart</span>
              Visitor Trends
            </h3>
            <p class="text-accent-gray text-sm mt-1">Last 7 days performance</p>
          </div>
          <select class="text-sm border border-primary-200 rounded-lg px-3 py-2 bg-white text-accent-dark">
            <option>Last 7 Days</option>
            <option>Last 30 Days</option>
            <option>This Month</option>
          </select>
        </div>
        <div class="p-4 md:p-6">
          <div class="space-y-4">
            <div v-for="(day, i) in visitorData" :key="i" class="flex items-center gap-4">
              <span class="w-12 text-accent-gray text-xs md:text-sm">{{ day.label }}</span>
              <div class="flex-1 h-10 bg-primary-50 rounded-xl relative overflow-hidden">
                <div 
                  class="h-full bg-gradient-to-r from-primary-500 to-primary-600 rounded-xl transition-all duration-700"
                  :style="{ width: `${(day.value / maxVisitors) * 100}%` }"
                ></div>
              </div>
              <span class="w-12 text-accent-dark font-medium text-xs md:text-sm text-right">{{ day.value }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white border border-primary-200 rounded-2xl shadow-sm">
        <div class="p-4 md:p-6 border-b border-primary-100 flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-accent-dark flex items-center gap-2">
              <span class="material-icons-round text-primary-600">notifications</span>
              Recent Activity
            </h3>
          </div>
          <button class="text-primary-600 hover:text-primary-700 text-sm font-medium">
            View All
          </button>
        </div>
        <div class="divide-y divide-primary-100 max-h-[400px] overflow-y-auto">
          <div
            v-for="activity in recentActivities"
            :key="activity.id"
            class="p-4 md:px-6"
          >
            <div class="flex items-start gap-3">
              <div class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0" :class="activity.bgClass">
                <span class="material-icons-round text-lg" :class="activity.iconClass">{{ activity.icon }}</span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-accent-dark text-sm font-medium">{{ activity.title }}</p>
                <p class="text-accent-gray text-xs mt-0.5">{{ activity.description }}</p>
                <p class="text-accent-gray/50 text-xs mt-1">{{ activity.time }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Top Products -->
    <div class="grid grid-cols-1 lg:grid-cols-1 gap-4 md:gap-6">
      <div class="bg-white border border-primary-200 rounded-2xl shadow-sm">
        <div class="p-4 md:p-6 border-b border-primary-100 flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-accent-dark flex items-center gap-2">
              <span class="material-icons-round text-primary-600">trending_up</span>
              Top Products
            </h3>
            <p class="text-accent-gray text-sm mt-1">Your best selling items</p>
          </div>
          <router-link to="/admin/products" class="text-primary-600 hover:text-primary-700 text-sm font-medium flex items-center gap-1">
            View All
            <span class="material-icons-round text-lg">arrow_forward</span>
          </router-link>
        </div>
        <div class="divide-y divide-primary-100">
          <div
            v-for="(product, i) in topProducts"
            :key="product.id"
            class="p-4 md:px-6"
          >
            <div class="flex items-center gap-4">
              <span class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center text-primary-700 font-semibold shrink-0">
                {{ i + 1 }}
              </span>
              <div class="flex-1 min-w-0">
                <p class="font-medium text-accent-dark truncate">{{ product.name }}</p>
                <p class="text-xs text-accent-gray mt-0.5">{{ product.view_count || 0 }} views</p>
              </div>
              <span class="text-accent-dark font-medium text-sm">
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
