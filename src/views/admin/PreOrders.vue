<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Pre-Orders</h3>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
      <div class="bg-white border-2 border-black rounded-lg p-4 shadow-sm">
        <p class="text-gray-500 text-xs">New</p>
        <p class="font-display text-xl font-bold text-black">{{ countByStatus('baru') }}</p>
      </div>
      <div class="bg-white border-2 border-black rounded-lg p-4 shadow-sm">
        <p class="text-gray-500 text-xs">Confirmed</p>
        <p class="font-display text-xl font-bold text-black">{{ countByStatus('dikonfirmasi') }}</p>
      </div>
      <div class="bg-white border-2 border-black rounded-lg p-4 shadow-sm">
        <p class="text-gray-500 text-xs">Processing</p>
        <p class="font-display text-xl font-bold text-black">{{ countByStatus('diproses') }}</p>
      </div>
      <div class="bg-white border-2 border-black rounded-lg p-4 shadow-sm">
        <p class="text-gray-500 text-xs">Shipped</p>
        <p class="font-display text-xl font-bold text-black">{{ countByStatus('dikirim') }}</p>
      </div>
    </div>

    <!-- Filter -->
    <div class="flex gap-2 flex-wrap">
      <button 
        v-for="s in statusFilters" 
        :key="s"
        @click="currentFilter = s"
        :class="['px-3 py-1.5 border-2 rounded-lg text-xs font-bold transition-all', currentFilter === s ? 'bg-black text-white border-black' : 'bg-white border-black text-black hover:bg-gray-100']"
      >
        {{ s === 'all' ? 'All Orders' : s }}
      </button>
    </div>

    <!-- Orders Table -->
    <div class="bg-white border-2 border-black rounded-lg overflow-x-auto shadow-sm">
      <table class="w-full min-w-[600px]">
        <thead class="bg-gray-100 border-b-2 border-black">
          <tr>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Order ID</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Customer</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Product</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Qty</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Platform</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Status</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Date</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="order in filteredOrders" :key="order.id" class="hover:bg-gray-50 transition-colors">
            <td class="px-3 py-3 text-gray-600 font-mono text-xs">#{{ order.id?.slice(0, 8) }}</td>
            <td class="px-3 py-3">
              <p class="font-semibold text-black text-sm">{{ order.nama_pemesan }}</p>
            </td>
            <td class="px-3 py-3 text-gray-600 text-sm">{{ order.produk }}</td>
            <td class="px-3 py-3 text-black font-semibold text-sm">{{ order.jumlah }}</td>
            <td class="px-3 py-3">
              <span class="capitalize text-gray-600 text-sm">{{ order.platform }}</span>
            </td>
            <td class="px-3 py-3">
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full" :class="getStatusClass(order.status)">
                {{ order.status }}
              </span>
            </td>
            <td class="px-3 py-3 text-gray-600 text-xs">
              {{ new Date(order.created_at).toLocaleDateString('id-ID') }}
            </td>
            <td class="px-3 py-3">
              <div class="flex gap-1.5">
                <button @click="viewDetail(order)" class="text-gray-600 hover:text-black px-2 py-1 text-xs font-bold rounded border border-gray-300 hover:border-black transition-all">View</button>
                <button @click="showStatusModal(order)" class="text-gray-600 hover:text-black px-2 py-1 text-xs font-bold rounded border border-gray-300 hover:border-black transition-all">Update</button>
              </div>
            </td>
          </tr>
          <tr v-if="filteredOrders.length === 0">
            <td colspan="8" class="px-6 py-8 text-center">
              <p class="text-gray-500 text-sm">No orders found</p>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-2xl w-full my-4 rounded-xl border-2 border-black shadow-xl overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-black">Order Details</h3>
          <button @click="showDetailModal = false" class="text-gray-500 hover:text-black hover:bg-gray-100 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <div v-if="selectedOrder" class="p-4 space-y-4">
          <!-- Order Info -->
          <div class="grid grid-cols-2 gap-3">
            <div>
              <p class="text-gray-500 text-xs">Customer Name</p>
              <p class="font-semibold text-black text-sm">{{ selectedOrder.nama_pemesan }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">Platform</p>
              <p class="font-semibold text-black text-sm capitalize">{{ selectedOrder.platform }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">Product</p>
              <p class="font-semibold text-black text-sm">{{ selectedOrder.produk }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">Quantity</p>
              <p class="font-semibold text-black text-sm">{{ selectedOrder.jumlah }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">Status</p>
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full" :class="getStatusClass(selectedOrder.status)">
                {{ selectedOrder.status }}
              </span>
            </div>
            <div>
              <p class="text-gray-500 text-xs">Order Date</p>
              <p class="font-semibold text-black text-sm">{{ new Date(selectedOrder.created_at).toLocaleString('id-ID') }}</p>
            </div>
          </div>

          <!-- Status Timeline -->
          <div>
            <h4 class="font-bold text-black text-sm mb-3">Status History</h4>
            <div class="space-y-3">
              <div v-for="(history, idx) in (selectedOrder.status_history || [])" :key="idx" class="flex gap-3">
                <div class="flex flex-col items-center">
                  <div class="w-2.5 h-2.5 bg-red-600 rounded-full"></div>
                  <div v-if="idx < (selectedOrder.status_history?.length || 0) - 1" class="w-0.5 flex-1 bg-gray-200"></div>
                </div>
                <div class="pb-3">
                  <p class="font-semibold text-black text-sm">{{ history.status }}</p>
                  <p class="text-gray-500 text-xs">{{ history.note || 'No note' }}</p>
                  <p class="text-gray-400 text-[10px]">{{ new Date(history.timestamp).toLocaleString('id-ID') }}</p>
                </div>
              </div>
              <div class="flex gap-3">
                <div class="flex flex-col items-center">
                  <div class="w-2.5 h-2.5 bg-gray-400 rounded-full"></div>
                </div>
                <div class="pb-3">
                  <p class="font-semibold text-black text-sm">Order Created</p>
                  <p class="text-gray-400 text-[10px]">{{ new Date(selectedOrder.created_at).toLocaleString('id-ID') }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="p-4 border-t-2 border-black flex justify-end gap-2.5">
          <button @click="showDetailModal = false" class="px-4 py-2 rounded-lg border-2 border-black text-black font-bold hover:bg-gray-50 transition-colors text-xs">Close</button>
          <button @click="showStatusModal(selectedOrder)" class="px-4 py-2 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">Update Status</button>
        </div>
      </div>
    </div>

    <!-- Status Update Modal -->
    <div v-if="showStatusModal" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div class="bg-white max-w-md w-full rounded-xl border-2 border-black shadow-xl overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between">
          <h3 class="font-bold text-black">Update Status</h3>
          <button @click="showStatusModal = false" class="text-gray-500 hover:text-black hover:bg-gray-100 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="updateStatus" class="p-4 space-y-4">
          <div>
            <label class="block text-xs font-bold text-black mb-1">New Status</label>
            <select v-model="statusForm.status" required class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              <option value="baru">Baru</option>
              <option value="dikonfirmasi">Dikonfirmasi</option>
              <option value="diproses">Diproses</option>
              <option value="dikirim">Dikirim</option>
              <option value="selesai">Selesai</option>
              <option value="dibatalkan">Dibatalkan</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Note (optional)</label>
            <textarea v-model="statusForm.note" rows="3" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs" placeholder="Add a note..."></textarea>
          </div>
          <div class="flex gap-2.5 pt-2">
            <button type="button" @click="showStatusModal = false" class="flex-1 px-4 py-2.5 rounded-lg border-2 border-black text-black font-bold hover:bg-gray-50 transition-colors text-xs">Cancel</button>
            <button type="submit" class="flex-1 px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">Update Status</button>
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

function updateStatus() {
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
  
  console.log('Updating order status:', {
    id: selectedOrder.value.id,
    status: statusForm.value.status,
    status_history: newHistory
  })
  
  showStatusModal.value = false
}

function getStatusClass(status) {
  const classes = {
    baru: 'bg-gray-100 text-gray-800 border border-gray-300',
    dikonfirmasi: 'bg-blue-100 text-blue-800 border border-blue-300',
    diproses: 'bg-yellow-100 text-yellow-800 border border-yellow-300',
    dikirim: 'bg-purple-100 text-purple-800 border border-purple-300',
    selesai: 'bg-green-100 text-green-800 border border-green-300',
    dibatalkan: 'bg-red-100 text-red-800 border border-red-300'
  }
  return classes[status] || 'bg-gray-100 text-gray-800 border border-gray-300'
}
</script>