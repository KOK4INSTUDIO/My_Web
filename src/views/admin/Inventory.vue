<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Inventory Logs</h3>
      <button @click="showAdjustModal = true" class="px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">+ Adjust Stock</button>
    </div>

    <!-- Stock Summary -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Total Items</p>
        <p class="font-display text-2xl font-bold text-black">{{ totalItems }}</p>
      </div>
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Low Stock</p>
        <p class="font-display text-2xl font-bold text-red-600">{{ lowStockCount }}</p>
      </div>
      <div class="bg-white border-2 border-black rounded-lg shadow-sm p-4">
        <p class="text-gray-600 text-xs mb-1">Out of Stock</p>
        <p class="font-display text-2xl font-bold text-black">{{ outOfStockCount }}</p>
      </div>
    </div>

    <!-- Inventory Logs Table -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-x-auto">
      <table class="w-full">
        <thead class="bg-gray-50 border-b-2 border-black">
          <tr>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Date</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Product</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Type</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Qty</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Stock Before</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Stock After</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Note</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Admin</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="log in inventoryLogs" :key="log.id" class="hover:bg-gray-50">
            <td class="px-3 py-2 text-gray-600 text-xs">
              {{ new Date(log.created_at).toLocaleString('id-ID') }}
            </td>
            <td class="px-3 py-2 text-black text-xs">{{ log.product?.name || 'Unknown' }}</td>
            <td class="px-3 py-2">
              <span class="px-2 py-1 text-[10px] font-bold rounded" :class="getTypeClass(log.type)">
                {{ log.type }}
              </span>
            </td>
            <td class="px-3 py-2 text-black font-bold text-xs" :class="{ 'text-green-600': log.type === 'in', 'text-red-600': log.type === 'out' }">
              {{ log.type === 'in' ? '+' : '' }}{{ log.quantity }}
            </td>
            <td class="px-3 py-2 text-gray-600 text-xs">{{ log.stock_before }}</td>
            <td class="px-3 py-2 text-black font-bold text-xs">{{ log.stock_after }}</td>
            <td class="px-3 py-2 text-gray-600 text-xs max-w-xs truncate">{{ log.note || '-' }}</td>
            <td class="px-3 py-2 text-gray-600 text-xs">{{ log.admin_id?.slice(0, 8) || '-' }}</td>
          </tr>
          <tr v-if="inventoryLogs.length === 0">
            <td colspan="8" class="px-6 py-8 text-center text-gray-600 text-xs">
              No inventory logs yet
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Adjust Stock Modal -->
    <div v-if="showAdjustModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="bg-white max-w-lg w-full border-2 border-black rounded-lg shadow-lg overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between bg-gray-50">
          <h3 class="font-bold text-black text-sm">Adjust Stock</h3>
          <button @click="showAdjustModal = false" class="text-gray-600 hover:text-black text-xl">✕</button>
        </div>
        <form @submit.prevent="adjustStock" class="p-4 space-y-4">
          <div>
            <label class="block text-xs font-bold text-black mb-1">Product</label>
            <select v-model="adjustForm.product_id" required class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
              <option value="">Select product...</option>
              <option v-for="product in products" :key="product.id" :value="product.id">
                {{ product.name }} (Stock: {{ product.stock }})
              </option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Type</label>
            <select v-model="adjustForm.type" required class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
              <option value="in">Stock In (+)</option>
              <option value="out">Stock Out (-)</option>
              <option value="adjustment">Adjustment</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Quantity</label>
            <input v-model.number="adjustForm.quantity" type="number" min="1" required class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Note</label>
            <textarea v-model="adjustForm.note" rows="2" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs" placeholder="Reason for adjustment..."></textarea>
          </div>
          <div class="flex gap-3 pt-2">
            <button type="button" @click="showAdjustModal = false" class="flex-1 px-4 py-2 rounded-lg border-2 border-black text-black font-bold hover:bg-gray-100 transition-colors text-xs">Cancel</button>
            <button type="submit" class="flex-1 px-4 py-2 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors text-xs">Confirm Adjustment</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const inventoryLogs = ref([])
const products = ref([])
const showAdjustModal = ref(false)

const adjustForm = ref({
  product_id: '',
  type: 'in',
  quantity: 0,
  note: ''
})

const totalItems = computed(() => products.value.reduce((sum, p) => sum + p.stock, 0))
const lowStockCount = computed(() => products.value.filter(p => p.stock < 10 && p.stock > 0).length)
const outOfStockCount = computed(() => products.value.filter(p => p.stock === 0).length)

onMounted(async () => {
  await loadLogs()
  await loadProducts()
})

async function loadLogs() {
  const { data } = await supabase
    .from('inventory_logs')
    .select('*, product:products(*)')
    .order('created_at', { ascending: false })
    .limit(50)
  
  inventoryLogs.value = data || []
}

async function loadProducts() {
  const { data } = await supabase.from('products').select('*').order('name')
  products.value = data || []
}

function getTypeClass(type) {
  const classes = {
    in: 'bg-green-100 text-green-800 border border-green-300',
    out: 'bg-red-100 text-red-800 border border-red-300',
    adjustment: 'bg-yellow-100 text-yellow-800 border border-yellow-300'
  }
  return classes[type] || 'bg-gray-100 text-gray-800 border border-gray-300'
}

function adjustStock() {
  console.log('Adjusting stock:', adjustForm.value)
  showAdjustModal.value = false
  adjustForm.value = { product_id: '', type: 'in', quantity: 0, note: '' }
}
</script>
