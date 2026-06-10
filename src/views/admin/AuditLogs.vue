<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Audit Logs</h3>
      <div class="flex gap-2">
        <select v-model="filterAction" class="px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 bg-white rounded-lg text-xs">
          <option value="">All Actions</option>
          <option value="create">Create</option>
          <option value="update">Update</option>
          <option value="delete">Delete</option>
        </select>
        <select v-model="filterTable" class="px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 bg-white rounded-lg text-xs">
          <option value="">All Tables</option>
          <option value="products">Products</option>
          <option value="categories">Categories</option>
          <option value="pre_orders">Pre-Orders</option>
          <option value="banners">Banners</option>
        </select>
      </div>
    </div>

    <!-- Audit Logs Table -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-x-auto">
      <table class="w-full">
        <thead class="bg-gray-50 border-b-2 border-black">
          <tr>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Timestamp</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Action</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Table</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Record ID</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Admin</th>
            <th class="px-3 py-2 text-left text-xs font-bold text-black">Changes</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="log in filteredLogs" :key="log.id" class="hover:bg-gray-50">
            <td class="px-3 py-2 text-gray-600 text-xs">
              {{ new Date(log.created_at).toLocaleString('id-ID') }}
            </td>
            <td class="px-3 py-2">
              <span class="px-2 py-1 text-[10px] font-bold rounded" :class="getActionClass(log.action)">
                {{ log.action }}
              </span>
            </td>
            <td class="px-3 py-2 text-black text-xs">{{ log.table_name || '-' }}</td>
            <td class="px-3 py-2 text-gray-600 text-xs font-mono">{{ log.record_id?.slice(0, 12) || '-' }}</td>
            <td class="px-3 py-2 text-gray-600 text-xs">{{ log.admin_id?.slice(0, 8) || '-' }}</td>
            <td class="px-3 py-2">
              <div class="space-y-1 max-w-md">
                <div v-if="log.old_data" class="text-[10px]">
                  <span class="text-red-600">-</span>
                  <span class="text-gray-600">{{ JSON.stringify(log.old_data) }}</span>
                </div>
                <div v-if="log.new_data" class="text-[10px]">
                  <span class="text-green-600">+</span>
                  <span class="text-gray-600">{{ JSON.stringify(log.new_data) }}</span>
                </div>
              </div>
            </td>
          </tr>
          <tr v-if="filteredLogs.length === 0">
            <td colspan="6" class="px-6 py-8 text-center text-gray-600 text-xs">
              No audit logs found
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-between text-xs text-gray-600">
      <span>Showing {{ filteredLogs.length }} entries</span>
      <div class="flex gap-2">
        <button class="px-3 py-1 border-2 border-black hover:bg-gray-100 rounded text-xs font-bold">Prev</button>
        <button class="px-3 py-1 border-2 border-black hover:bg-gray-100 rounded text-xs font-bold">Next</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const auditLogs = ref([])
const filterAction = ref('')
const filterTable = ref('')

const filteredLogs = computed(() => {
  let logs = auditLogs.value
  if (filterAction.value) {
    logs = logs.filter(l => l.action === filterAction.value)
  }
  if (filterTable.value) {
    logs = logs.filter(l => l.table_name === filterTable.value)
  }
  return logs
})

onMounted(async () => {
  await loadLogs()
})

async function loadLogs() {
  // Mock data for demonstration
  auditLogs.value = [
    {
    id: 1,
    action: 'create',
    table_name: 'products',
    record_id: 'abc123-def456',
    admin_id: 'ebbe93d3-acc4-4937-b546-0aa142e36b7e',
    old_data: null,
    new_data: { name: 'New Product', price: 199000 },
    created_at: new Date(Date.now() - 1000 * 60 * 30)
  },
  {
    id: 2,
    action: 'update',
    table_name: 'products',
    record_id: 'abc123-def456',
    admin_id: 'ebbe93d3-acc4-4937-b546-0aa142e36b7e',
    old_data: { stock: 50 },
    new_data: { stock: 100 },
    created_at: new Date(Date.now() - 1000 * 60 * 60 * 2)
  },
  {
    id: 3,
    action: 'create',
    table_name: 'pre_orders',
    record_id: 'xyz789-ghi012',
    admin_id: 'ebbe93d3-acc4-4937-b546-0aa142e36b7e',
    old_data: null,
    new_data: { status: 'dikonfirmasi' },
    created_at: new Date(Date.now() - 1000 * 60 * 60 * 24)
  }
]
}

function getActionClass(action) {
  const classes = {
    create: 'bg-green-100 text-green-800 border border-green-300',
    update: 'bg-blue-100 text-blue-800 border border-blue-300',
    delete: 'bg-red-100 text-red-800 border border-red-300'
  }
  return classes[action] || 'bg-gray-100 text-gray-800 border border-gray-300'
}
</script>
