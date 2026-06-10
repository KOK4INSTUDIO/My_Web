<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Visitor Analytics</h3>
    </div>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Total Page Views</p>
        <p class="font-display text-2xl font-bold text-black">{{ analytics.pageViews.toLocaleString() }}</p>
      </div>
      
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Product Views</p>
        <p class="font-display text-2xl font-bold text-black">{{ analytics.productViews.toLocaleString() }}</p>
      </div>
      
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Platform Clicks</p>
        <p class="font-display text-2xl font-bold text-black">{{ analytics.platformClicks.toLocaleString() }}</p>
      </div>
    </div>
    
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
      <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50">
          <h3 class="font-bold text-black text-sm">Top Products</h3>
        </div>
        <div class="divide-y divide-gray-200">
          <div
            v-for="(product, index) in topProducts"
            :key="product.product_id"
            class="px-4 py-3 flex items-center justify-between"
          >
            <div class="flex items-center gap-3">
              <span class="w-7 h-7 bg-gray-100 flex items-center justify-center text-gray-600 font-bold text-xs rounded">
                {{ index + 1 }}
              </span>
              <span class="text-black text-xs">Product #{{ product.product_id?.slice(0, 8) }}...</span>
            </div>
            <span class="font-bold text-black text-xs">{{ product.count }} views</span>
          </div>
          <div v-if="topProducts.length === 0" class="px-4 py-8 text-center text-gray-600 text-xs">
            No data available
          </div>
        </div>
      </div>
      
      <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
        <div class="p-4 border-b-2 border-black bg-gray-50">
          <h3 class="font-bold text-black text-sm">Device Types</h3>
        </div>
        <div class="divide-y divide-gray-200">
          <div
            v-for="device in deviceTypes"
            :key="device.device_type"
            class="px-4 py-3 flex items-center justify-between"
          >
            <span class="text-black capitalize text-xs">{{ device.device_type || 'Unknown' }}</span>
            <span class="font-bold text-black text-xs">{{ device.count }}</span>
          </div>
          <div v-if="deviceTypes.length === 0" class="px-4 py-8 text-center text-gray-600 text-xs">
            No data available
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const analytics = ref({
  pageViews: 0,
  productViews: 0,
  platformClicks: 0
})

const topProducts = ref([])
const deviceTypes = ref([])

onMounted(async () => {
  await loadAnalytics()
})

async function loadAnalytics() {
  const [
    { count: pageViews },
    { count: productViews },
    { count: platformClicks },
    { data: productsData },
    { data: devicesData }
  ] = await Promise.all([
    supabase.from('visitor_events').select('*', { count: 'exact', head: true }).eq('event_type', 'page_view'),
    supabase.from('visitor_events').select('*', { count: 'exact', head: true }).eq('event_type', 'product_view'),
    supabase.from('visitor_events').select('*', { count: 'exact', head: true }).in('event_type', ['whatsapp_click', 'shopee_click', 'tokopedia_click']),
    supabase
      .from('visitor_events')
      .select('product_id')
      .eq('event_type', 'product_view')
      .not('product_id', 'is', null),
    supabase
      .from('visitor_events')
      .select('device_type')
  ])
  
  analytics.value = {
    pageViews: pageViews || 0,
    productViews: productViews || 0,
    platformClicks: platformClicks || 0
  }
  
  const productCounts = {}
  productsData?.forEach(p => {
    if (p.product_id) {
      productCounts[p.product_id] = (productCounts[p.product_id] || 0) + 1
    }
  })
  
  topProducts.value = Object.entries(productCounts)
    .map(([product_id, count]) => ({ product_id, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 5)
  
  const deviceCounts = {}
  devicesData?.forEach(d => {
    const type = d.device_type || 'Unknown'
    deviceCounts[type] = (deviceCounts[type] || 0) + 1
  })
  
  deviceTypes.value = Object.entries(deviceCounts)
    .map(([device_type, count]) => ({ device_type, count }))
    .sort((a, b) => b.count - a.count)
}
</script>
