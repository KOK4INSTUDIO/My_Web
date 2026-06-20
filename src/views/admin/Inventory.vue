<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-black">Inventory</h3>
    </div>

    <!-- Products List -->
    <div class="bg-white border border-gray-200 rounded-lg overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full" style="min-width: 700px;">
          <thead>
            <tr class="bg-gray-50 border-b border-gray-200">
              <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Product</th>
              <th class="px-5 py-4 text-left text-xs font-bold text-gray-700 hidden md:table-cell">SKU</th>
              <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Current Stock</th>
              <th class="px-5 py-4 text-left text-xs font-bold text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="product in products" :key="product.id" class="hover:bg-gray-50 transition-colors">
              <td class="px-5 py-4">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 bg-gray-100 border border-gray-200 rounded flex items-center justify-center overflow-hidden">
                    <span v-if="product.gallery && product.gallery[0]" class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: 'url(' + product.gallery[0] + ')' }"></span>
                    <span v-else class="material-icons-round text-gray-400 text-base">image</span>
                  </div>
                  <div>
                    <p class="font-medium text-accent-black text-sm">{{ product.name }}</p>
                    <p class="text-xs text-gray-500 hidden md:block">{{ product.slug }}</p>
                  </div>
                </div>
              </td>
              <td class="px-5 py-4 text-gray-500 font-mono text-xs hidden md:table-cell">{{ product.sku || '-' }}</td>
              <td class="px-5 py-4 text-sm" :class="{ 'text-red-600 font-medium': product.stock < 10 }">
                {{ product.stock }}
              </td>
              <td class="px-5 py-4">
                <div class="flex items-center gap-2">
                  <button @click="showStockModalFunc(product, 'in')" class="text-green-600 hover:text-green-700 px-3 py-1.5 border border-green-200 rounded hover:bg-green-50 transition-colors text-xs font-medium">
                    + Stock In
                  </button>
                  <button @click="showStockModalFunc(product, 'out')" class="text-red-600 hover:text-red-700 px-3 py-1.5 border border-red-200 rounded hover:bg-red-50 transition-colors text-xs font-medium">
                    - Stock Out
                  </button>
                  <button @click="showLogModalFunc(product)" class="text-gray-500 hover:text-accent-black p-1.5 rounded transition-colors">
                    <span class="material-icons-round text-lg">history</span>
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="products.length === 0">
              <td colspan="4" class="px-6 py-12 text-center">
                <span class="material-icons-round text-5xl mb-3 block text-gray-300">inventory</span>
                <p class="text-gray-500 text-sm">No products yet. Add your first product!</p>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Stock In/Out Modal -->
    <div v-if="showStockModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-md w-full my-4 rounded-xl border border-gray-200 shadow-lg overflow-hidden">
        <div class="p-5 border-b border-gray-200 flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-accent-black flex items-center gap-2">
            <span class="material-icons-round" :class="stockForm.type === 'in' ? 'text-green-600' : 'text-red-600'">
              {{ stockForm.type === 'in' ? 'add_circle' : 'remove_circle' }}
            </span>
            {{ stockForm.type === 'in' ? 'Stock In' : 'Stock Out' }}
          </h3>
          <button @click="showStockModal = false" class="text-gray-400 hover:text-accent-black hover:bg-gray-50 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="saveStock" class="p-5 space-y-4">
          <div v-if="selectedProduct">
            <p class="text-gray-700 text-sm mb-1">Product: <span class="font-medium text-accent-black">{{ selectedProduct.name }}</span></p>
            <p class="text-gray-500 text-xs mb-4">Current Stock: <span class="font-medium">{{ selectedProduct.stock }}</span></p>
          </div>
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Quantity</label>
            <input v-model.number="stockForm.quantity" type="number" required min="1" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm">
          </div>
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Note (optional)</label>
            <textarea v-model="stockForm.note" rows="3" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm" placeholder="Add a note..."></textarea>
          </div>
          <div class="flex gap-3 pt-3 border-t border-gray-200">
            <button type="button" @click="showStockModal = false" class="flex-1 px-5 py-2.5 border border-gray-300 text-accent-black font-medium hover:bg-gray-50 transition-colors text-sm">Cancel</button>
            <button type="submit" :class="['flex-1 px-5 py-2.5 font-medium text-white transition-colors text-sm', stockForm.type === 'in' ? 'bg-green-600 hover:bg-green-700' : 'bg-red-600 hover:bg-red-700']">
              {{ stockForm.type === 'in' ? 'Add Stock' : 'Remove Stock' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Stock Log Modal -->
    <div v-if="showLogModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-3xl w-full my-4 rounded-xl border border-gray-200 shadow-lg overflow-hidden">
        <div class="p-5 border-b border-gray-200 flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-accent-black flex items-center gap-2">
            <span class="material-icons-round">history</span>
            Stock History
            <span v-if="selectedProduct" class="text-gray-500 font-normal">- {{ selectedProduct.name }}</span>
          </h3>
          <button @click="showLogModal = false" class="text-gray-400 hover:text-accent-black hover:bg-gray-50 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <div class="p-5">
          <div class="space-y-3 max-h-96 overflow-y-auto">
            <div v-for="log in productLogs" :key="log.id" class="flex gap-4 pb-3 border-b border-gray-100 last:border-b-0">
              <div class="flex flex-col items-center">
                <div :class="['w-2.5 h-2.5 rounded-full', log.type === 'in' ? 'bg-green-600' : 'bg-red-600']"></div>
              </div>
              <div class="flex-1">
                <div class="flex items-center justify-between mb-1">
                  <p class="text-sm font-medium text-accent-black">
                    {{ log.type === 'in' ? 'Stock In' : 'Stock Out' }}
                    <span :class="['text-xs font-bold', log.type === 'in' ? 'text-green-600' : 'text-red-600']">
                      {{ log.type === 'in' ? '+' : '-' }}{{ log.quantity }}
                    </span>
                  </p>
                  <p class="text-xs text-gray-500">{{ new Date(log.created_at).toLocaleString('id-ID') }}</p>
                </div>
                <p class="text-xs text-gray-600 mb-1">Before: {{ log.stock_before }} → After: {{ log.stock_after }}</p>
                <p v-if="log.note" class="text-xs text-gray-500">{{ log.note }}</p>
              </div>
            </div>
            <div v-if="productLogs.length === 0" class="text-center py-6">
              <p class="text-gray-500 text-sm">No stock history yet.</p>
            </div>
          </div>
        </div>
        <div class="p-5 border-t border-gray-200 flex justify-end">
          <button @click="showLogModal = false" class="px-5 py-2.5 border border-gray-300 text-accent-black font-medium hover:bg-gray-50 transition-colors text-sm">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const showStockModal = ref(false)
const showLogModal = ref(false)
const selectedProduct = ref(null)
const productLogs = ref([])

const stockForm = ref({
  type: 'in',
  quantity: 0,
  note: ''
})

onMounted(async () => {
  await loadProducts()
})

async function loadProducts() {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .order('name')
    
    if (error) throw error
    products.value = data || []
  } catch (error) {
    console.error('Error loading products:', error)
  }
}

async function showStockModalFunc(product, type) {
  selectedProduct.value = product
  stockForm.value = { type, quantity: 0, note: '' }
  showStockModal.value = true
}

async function showLogModalFunc(product) {
  selectedProduct.value = product
  await loadProductLogs(product.id)
  showLogModal.value = true
}

async function loadProductLogs(productId) {
  try {
    const { data, error } = await supabase
      .from('inventory_logs')
      .select('*')
      .eq('product_id', productId)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    productLogs.value = data || []
  } catch (error) {
    console.error('Error loading logs:', error)
  }
}

async function saveStock() {
  if (!selectedProduct.value || stockForm.value.quantity <= 0) return

  const product = selectedProduct.value
  const stockBefore = product.stock
  let stockAfter

  if (stockForm.value.type === 'in') {
    stockAfter = stockBefore + stockForm.value.quantity
  } else {
    stockAfter = stockBefore - stockForm.value.quantity
    if (stockAfter < 0) {
      alert('Stock tidak cukup!')
      return
    }
  }

  try {
    // Update product stock
    await supabase.from('products').update({ stock: stockAfter }).eq('id', product.id)

    // Insert log
    await supabase.from('inventory_logs').insert({
      product_id: product.id,
      type: stockForm.value.type,
      quantity: stockForm.value.quantity,
      stock_before: stockBefore,
      stock_after: stockAfter,
      note: stockForm.value.note
    })

    await loadProducts()
    showStockModal.value = false
  } catch (error) {
    console.error('Error updating stock:', error)
  }
}
</script>
