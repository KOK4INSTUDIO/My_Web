<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-black">Pre-Orders</h3>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div class="bg-white border border-gray-200 rounded-lg p-5">
        <p class="text-gray-500 text-xs mb-1">New</p>
        <p class="font-display text-2xl font-bold text-accent-black">{{ countByStatus('baru') }}</p>
      </div>
      <div class="bg-white border border-gray-200 rounded-lg p-5">
        <p class="text-gray-500 text-xs mb-1">Confirmed</p>
        <p class="font-display text-2xl font-bold text-accent-black">{{ countByStatus('dikonfirmasi') }}</p>
      </div>
      <div class="bg-white border border-gray-200 rounded-lg p-5">
        <p class="text-gray-500 text-xs mb-1">Processing</p>
        <p class="font-display text-2xl font-bold text-accent-black">{{ countByStatus('diproses') }}</p>
      </div>
      <div class="bg-white border border-gray-200 rounded-lg p-5">
        <p class="text-gray-500 text-xs mb-1">Shipped</p>
        <p class="font-display text-2xl font-bold text-accent-black">{{ countByStatus('dikirim') }}</p>
      </div>
    </div>

    <!-- Filter -->
    <div class="flex flex-wrap gap-2">
      <button 
        v-for="s in statusFilters" 
        :key="s"
        @click="currentFilter = s"
        :class="[
          'px-4 py-2 border border-gray-300 rounded-lg text-xs font-medium transition-all',
          currentFilter === s ? 'bg-accent-black text-white border-accent-black' : 'bg-white text-gray-700 hover:bg-gray-50'
        ]"
      >
        {{ s === 'all' ? 'All Orders' : s }}
      </button>
    </div>

    <!-- Orders Table -->
    <div class="bg-white border border-gray-200 rounded-lg overflow-x-auto">
      <table class="w-full" style="min-width: 700px;">
        <thead>
          <tr class="bg-gray-50 border-b border-gray-200">
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Order ID</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Customer</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Product</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Qty</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700 hidden md:table-cell">Platform</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Status</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700 hidden md:table-cell">Date</th>
            <th class="px-5 py-4 text-right text-xs font-bold text-gray-700">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr v-for="order in filteredOrders" :key="order.id" class="hover:bg-gray-50 transition-colors">
            <td class="px-5 py-4 text-gray-600 font-mono text-xs">#{{ order.id?.slice(0, 8) }}</td>
            <td class="px-5 py-4">
              <p class="font-medium text-accent-black text-sm">{{ order.nama_pemesan }}</p>
            </td>
            <td class="px-5 py-4 text-gray-600 text-sm">{{ order.produk }}</td>
            <td class="px-5 py-4 text-accent-black font-medium text-sm">{{ order.jumlah }}</td>
            <td class="px-5 py-4 text-gray-600 text-sm hidden md:table-cell capitalize">{{ order.platform }}</td>
            <td class="px-5 py-4">
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full bg-gray-100 text-gray-800" :class="getStatusClass(order.status)">
                {{ order.status }}
              </span>
            </td>
            <td class="px-5 py-4 text-gray-500 text-xs hidden md:table-cell">
              {{ new Date(order.created_at).toLocaleDateString('id-ID') }}
            </td>
            <td class="px-5 py-4 text-right">
              <div class="flex items-center justify-end gap-2">
                <button @click="viewDetail(order)" class="text-gray-500 hover:text-accent-black p-1.5 rounded transition-colors">
                  <span class="material-icons-round text-lg">visibility</span>
                </button>
                <button @click="showStatusModal(order)" class="text-gray-500 hover:text-accent-black p-1.5 rounded transition-colors">
                  <span class="material-icons-round text-lg">edit</span>
                </button>
              </div>
            </td>
          </tr>
          <tr v-if="filteredOrders.length === 0">
            <td colspan="8" class="px-6 py-12 text-center">
              <span class="material-icons-round text-5xl mb-3 block text-gray-300">shopping_cart</span>
              <p class="text-gray-500 text-sm">No orders found.</p>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-2xl w-full my-4 rounded-xl border border-gray-200 shadow-lg overflow-hidden">
        <div class="p-5 border-b border-gray-200 flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-accent-black">Order Details</h3>
          <button @click="showDetailModal = false" class="text-gray-400 hover:text-accent-black hover:bg-gray-50 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <div v-if="selectedOrder" class="p-5 space-y-5">
          <!-- Order Info -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <p class="text-gray-500 text-xs mb-1">Customer Name</p>
              <p class="font-medium text-accent-black text-sm">{{ selectedOrder.nama_pemesan }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs mb-1">Platform</p>
              <p class="font-medium text-accent-black text-sm capitalize">{{ selectedOrder.platform }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs mb-1">Product</p>
              <p class="font-medium text-accent-black text-sm">{{ selectedOrder.produk }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs mb-1">Quantity</p>
              <p class="font-medium text-accent-black text-sm">{{ selectedOrder.jumlah }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs mb-1">Status</p>
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full bg-gray-100 text-gray-800" :class="getStatusClass(selectedOrder.status)">
                {{ selectedOrder.status }}
              </span>
            </div>
            <div>
              <p class="text-gray-500 text-xs mb-1">Order Date</p>
              <p class="font-medium text-accent-black text-sm">{{ new Date(selectedOrder.created_at).toLocaleString('id-ID') }}</p>
            </div>
          </div>

          <!-- Status History -->
          <div>
            <h4 class="font-bold text-accent-black text-sm mb-3">Status History</h4>
            <div class="space-y-3">
              <div v-for="(history, idx) in (selectedOrder.status_history || [])" :key="idx" class="flex gap-3">
                <div class="flex flex-col items-center">
                  <div class="w-2.5 h-2.5 bg-accent-black rounded-full"></div>
                  <div v-if="idx < (selectedOrder.status_history?.length || 0) - 1" class="w-0.5 flex-1 bg-gray-200"></div>
                </div>
                <div class="pb-3">
                  <p class="font-medium text-accent-black text-sm">{{ history.status }}</p>
                  <p v-if="history.note" class="text-gray-500 text-xs">{{ history.note }}</p>
                  <p class="text-gray-400 text-[10px]">{{ new Date(history.timestamp).toLocaleString('id-ID') }}</p>
                </div>
              </div>
              <div class="flex gap-3">
                <div class="flex flex-col items-center">
                  <div class="w-2.5 h-2.5 bg-gray-400 rounded-full"></div>
                </div>
                <div class="pb-3">
                  <p class="font-medium text-accent-black text-sm">Order Created</p>
                  <p class="text-gray-400 text-[10px]">{{ new Date(selectedOrder.created_at).toLocaleString('id-ID') }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="p-5 border-t border-gray-200 flex justify-end gap-3">
          <button @click="showDetailModal = false" class="px-5 py-2.5 border border-gray-300 text-accent-black font-medium hover:bg-gray-50 transition-colors text-sm">Close</button>
          <button @click="showStatusModal(selectedOrder)" class="px-5 py-2.5 bg-accent-black text-white font-medium hover:bg-accent-dark transition-colors text-sm">Update Status</button>
        </div>
      </div>
    </div>

    <!-- Status Update Modal -->
    <div v-if="showStatusModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="bg-white max-w-md w-full rounded-xl border border-gray-200 shadow-lg overflow-hidden">
        <div class="p-5 border-b border-gray-200 flex items-center justify-between">
          <h3 class="font-bold text-accent-black">Update Status</h3>
          <button @click="showStatusModal = false" class="text-gray-400 hover:text-accent-black hover:bg-gray-50 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="updateStatus" class="p-5 space-y-4">
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">New Status</label>
            <select v-model="statusForm.status" required class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm bg-white">
              <option value="baru">Baru</option>
              <option value="dikonfirmasi">Dikonfirmasi</option>
              <option value="diproses">Diproses</option>
              <option value="dikirim">Dikirim</option>
              <option value="selesai">Selesai</option>
              <option value="dibatalkan">Dibatalkan</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Note (optional)</label>
            <textarea v-model="statusForm.note" rows="3" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm" placeholder="Add a note..."></textarea>
          </div>
          <div class="flex gap-3 pt-2">
            <button type="button" @click="showStatusModal = false" class="flex-1 px-5 py-2.5 border border-gray-300 text-accent-black font-medium hover:bg-gray-50 transition-colors text-sm">Cancel</button>
            <button type="submit" class="flex-1 px-5 py-2.5 bg-accent-black text-white font-medium hover:bg-accent-dark transition-colors text-sm">Update</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const preOrders = ref([])
const showDetailModal = ref(false)
const showStatusModal = ref(false)
const selectedOrder = ref(null)
const currentFilter = ref('all')

const statusFilters = ['all', 'baru', 'dikonfirmasi', 'diproses', 'dikirim', 'selesai', 'dibatalkan']

const statusForm = ref({
  status: '',
  note: ''
})

const filteredOrders = computed(() => {
  if (currentFilter.value === 'all') return preOrders.value
  return preOrders.value.filter(o => o.status === currentFilter.value)
})

onMounted(async () => {
  await loadOrders()
})

async function loadOrders() {
  const { data } = await supabase
    .from('pre_orders')
    .select('*')
    .order('created_at', { ascending: false })
  
  preOrders.value = data || []
}

function countByStatus(status) {
  return preOrders.value.filter(o => o.status === status).length
}

function viewDetail(order) {
  selectedOrder.value = order
  showDetailModal.value = true
}

function showStatusModal(order) {
  selectedOrder.value = order
  statusForm.value.status = order.status
  statusForm.value.note = ''
  showStatusModal.value = true
  showDetailModal.value = false
}

async function updateStatus() {
  if (!selectedOrder.value) return
  
  // Update status with history
  const newHistory = [
    ...(selectedOrder.value.status_history || []),
    {
      status: statusForm.value.status,
      note: statusForm.value.note,
      timestamp: new Date().toISOString()
    }
  ]
  
  await supabase.from('pre_orders').update({
    status: statusForm.value.status,
    status_history: newHistory
  }).eq('id', selectedOrder.value.id)
  
  await loadOrders()
  showStatusModal.value = false
}

function getStatusClass(status) {
  const classes = {
    baru: 'bg-gray-100 text-gray-800',
    dikonfirmasi: 'bg-blue-100 text-blue-800',
    diproses: 'bg-amber-100 text-amber-800',
    dikirim: 'bg-purple-100 text-purple-800',
    selesai: 'bg-green-100 text-green-800',
    dibatalkan: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}
</script>
