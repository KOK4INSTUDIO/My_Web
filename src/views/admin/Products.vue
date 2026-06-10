<template>
  <div class="space-y-5">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-3">
      <h3 class="font-display text-lg font-bold text-black">Products</h3>
      <button @click="showModal = true" class="flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg bg-red-600 text-white font-semibold hover:bg-red-700 transition-colors shadow-md text-sm">
        <span class="material-icons-round text-lg">add</span>
        Add
      </button>
    </div>

    <!-- Filter & Search -->
    <div class="flex flex-col md:flex-row gap-2 md:gap-3">
      <input 
        v-model="searchQuery"
        type="text" 
        placeholder="Search products..."
        class="flex-1 min-w-48 px-3 py-2.5 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm"
      >
      <select v-model="filterStatus" class="px-3 py-2.5 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        <option value="">All Status</option>
        <option value="draft">Draft</option>
        <option value="published">Published</option>
        <option value="best_seller">Best Seller</option>
        <option value="coming_soon">Coming Soon</option>
        <option value="out_of_stock">Out of Stock</option>
      </select>
      <select v-model="filterCategory" class="px-3 py-2.5 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        <option value="">All Categories</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>
    </div>

    <!-- Products Table -->
    <div class="bg-white border-2 border-black rounded-lg overflow-x-auto shadow-sm">
      <table class="w-full min-w-[700px]">
        <thead>
          <tr class="bg-gray-50 border-b-2 border-black">
            <th class="px-3 py-3 text-left text-xs font-bold text-black w-10"></th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Product</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">SKU</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black hidden md:table-cell">Category</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Price</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Stock</th>
            <th class="px-3 py-3 text-left text-xs font-bold text-black">Status</th>
            <th class="px-3 py-3 text-right text-xs font-bold text-black">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="product in filteredProducts" :key="product.id" class="hover:bg-gray-50 transition-colors">
            <td class="px-3 py-2.5">
              <div class="w-9 h-9 bg-gray-100 border border-gray-300 rounded flex items-center justify-center overflow-hidden">
                <span v-if="product.gallery?.[0]" class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: `url(${product.gallery[0]})` }"></span>
                <span v-else class="material-icons-round text-gray-500 text-base">image</span>
              </div>
            </td>
            <td class="px-3 py-2.5">
              <p class="font-semibold text-black text-sm">{{ product.name }}</p>
              <p class="text-xs text-gray-500 hidden md:block">{{ product.slug }}</p>
            </td>
            <td class="px-3 py-2.5 text-gray-600 font-mono text-xs">{{ product.sku || '-' }}</td>
            <td class="px-3 py-2.5 text-gray-600 text-xs hidden md:table-cell">{{ product.category?.name || '-' }}</td>
            <td class="px-3 py-2.5">
              <p class="text-black font-semibold text-sm">Rp {{ (product.promo_price || product.price)?.toLocaleString() }}</p>
              <p v-if="product.promo_price" class="text-gray-500 text-xs line-through hidden md:block">Rp {{ product.price?.toLocaleString() }}</p>
            </td>
            <td class="px-3 py-2.5 text-sm" :class="{ 'text-red-600 font-semibold': product.stock < 10 }">
              {{ product.stock }}
            </td>
            <td class="px-3 py-2.5">
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full" :class="getStatusClass(product.status)">
                {{ product.status }}
              </span>
            </td>
            <td class="px-3 py-2.5 text-right">
              <div class="flex items-center justify-end gap-1">
                <button class="text-gray-500 hover:text-black p-1.5 rounded transition-colors">
                  <span class="material-icons-round text-base">edit</span>
                </button>
                <button class="text-gray-500 hover:text-black p-1.5 rounded transition-colors">
                  <span class="material-icons-round text-base">content_copy</span>
                </button>
                <button class="text-red-600 hover:text-red-700 p-1.5 rounded transition-colors">
                  <span class="material-icons-round text-base">delete</span>
                </button>
              </div>
            </td>
          </tr>
          <tr v-if="filteredProducts.length === 0">
            <td colspan="8" class="px-6 py-8 text-center">
              <span class="material-icons-round text-4xl mb-2 block text-gray-300">inventory</span>
              <p class="text-gray-500 text-sm">No products found. Add your first product!</p>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Add/Edit Product Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-3 overflow-y-auto">
      <div class="bg-white max-w-2xl w-full my-3 rounded-xl border-2 border-black shadow-xl overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-black flex items-center gap-2">
            <span class="material-icons-round text-red-600">inventory_2</span>
            {{ editingId ? 'Edit Product' : 'Add Product' }}
          </h3>
          <button @click="showModal = false" class="text-gray-500 hover:text-black hover:bg-gray-100 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="saveProduct" class="p-4 space-y-4">
          <!-- Basic Info -->
          <div class="space-y-2.5">
            <h4 class="font-bold text-black border-l-4 border-red-500 pl-3 text-sm">Basic Information</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-2.5">
              <div class="md:col-span-2">
                <label class="block text-xs font-bold text-black mb-1">Product Name *</label>
                <input v-model="form.name" type="text" required @input="generateSlug" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              </div>
              <div class="md:col-span-2">
                <label class="block text-xs font-bold text-black mb-1">Slug *</label>
                <input v-model="form.slug" type="text" required class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              </div>
              <div>
                <label class="block text-xs font-bold text-black mb-1">SKU (auto)</label>
                <input v-model="form.sku" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-gray-300 bg-gray-50 text-gray-600 text-xs" readonly>
              </div>
              <div>
                <label class="block text-xs font-bold text-black mb-1">Category</label>
                <select v-model="form.category_id" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
                  <option value="">Select category...</option>
                  <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                </select>
              </div>
            </div>
            <div>
              <label class="block text-xs font-bold text-black mb-1">Description</label>
              <textarea v-model="form.description" rows="2" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs"></textarea>
            </div>
          </div>

          <!-- Pricing -->
          <div class="space-y-2.5">
            <h4 class="font-bold text-black border-l-4 border-red-500 pl-3 text-sm">Pricing & Stock</h4>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-2.5">
              <div>
                <label class="block text-xs font-bold text-black mb-1">Price *</label>
                <input v-model.number="form.price" type="number" required min="0" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              </div>
              <div>
                <label class="block text-xs font-bold text-black mb-1">Promo Price</label>
                <input v-model.number="form.promo_price" type="number" min="0" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              </div>
              <div>
                <label class="block text-xs font-bold text-black mb-1">Stock *</label>
                <input v-model.number="form.stock" type="number" required min="0" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              </div>
            </div>
          </div>

          <!-- Gallery -->
          <div class="space-y-2.5">
            <h4 class="font-bold text-black border-l-4 border-red-500 pl-3 text-sm">Gallery</h4>
            <div class="grid grid-cols-4 md:grid-cols-6 gap-1.5">
              <div v-for="(img, idx) in form.gallery" :key="idx" class="aspect-square bg-gray-50 border-2 border-gray-300 rounded-lg overflow-hidden relative group">
                <div class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: `url(${img})` }"></div>
                <button type="button" @click="form.gallery.splice(idx, 1)" class="absolute top-1 right-1 w-5 h-5 bg-red-600 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                  <span class="material-icons-round text-[10px]">close</span>
                </button>
              </div>
              <label class="aspect-square border-2 border-dashed border-gray-400 rounded-lg flex items-center justify-center cursor-pointer hover:border-red-500 hover:bg-red-50 transition-all">
                <span class="material-icons-round text-gray-500 text-xl">add_photo_alternate</span>
                <input type="file" accept="image/*" @change="addGalleryImage" class="hidden">
              </label>
            </div>
          </div>

          <!-- Status -->
          <div class="space-y-2.5">
            <h4 class="font-bold text-black border-l-4 border-red-500 pl-3 text-sm">Status</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-2.5">
              <div>
                <label class="block text-xs font-bold text-black mb-1">Status</label>
                <select v-model="form.status" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
                  <option value="draft">Draft</option>
                  <option value="published">Published</option>
                  <option value="best_seller">Best Seller</option>
                  <option value="coming_soon">Coming Soon</option>
                  <option value="out_of_stock">Out of Stock</option>
                </select>
              </div>
              <div class="flex items-end">
                <label class="flex items-center gap-1.5 cursor-pointer">
                  <input v-model="form.is_featured" type="checkbox" class="w-4 h-4 rounded text-red-600 focus:ring-red-500 border-black">
                  <span class="text-xs font-bold text-black">Featured</span>
                </label>
              </div>
            </div>
          </div>

          <div class="flex gap-2.5 pt-3 border-t-2 border-black">
            <button type="button" @click="showModal = false" class="flex-1 px-4 py-2.5 rounded-lg border-2 border-black text-black font-bold hover:bg-gray-50 transition-colors text-xs">Cancel</button>
            <button type="submit" class="flex-1 px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">{{ editingId ? 'Update' : 'Add' }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const categories = ref([])
const showModal = ref(false)
const editingId = ref(null)
const searchQuery = ref('')
const filterStatus = ref('')
const filterCategory = ref('')

const form = ref({
  name: '',
  slug: '',
  sku: '',
  category_id: null,
  description: '',
  price: 0,
  promo_price: null,
  stock: 0,
  gallery: [],
  status: 'draft',
  is_featured: false
})

const formSpecs = ref([])

const filteredProducts = computed(() => {
  let filtered = products.value
  if (searchQuery.value) {
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      p.sku?.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }
  if (filterStatus.value) {
    filtered = filtered.filter(p => p.status === filterStatus.value)
  }
  if (filterCategory.value) {
    filtered = filtered.filter(p => p.category_id === filterCategory.value)
  }
  return filtered
})

onMounted(async () => {
  await loadProducts()
  await loadCategories()
})

async function loadProducts() {
  const { data } = await supabase
    .from('products')
    .select('*, category:categories(*)')
    .order('created_at', { ascending: false })
  
  products.value = data || []
}

async function loadCategories() {
  const { data } = await supabase.from('categories').select('*').order('name')
  categories.value = data || []
}

function generateSlug() {
  if (form.value.name) {
    form.value.slug = form.value.name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')
    form.value.sku = 'PRD-' + Date.now().toString(36).toUpperCase()
  }
}

function addSpec() {
  formSpecs.value.push({ key: '', value: '' })
}

function addGalleryImage(event) {
  form.value.gallery.push('https://via.placeholder.com/400')
}

function saveProduct() {
  form.value.specifications = Object.fromEntries(formSpecs.value.filter(s => s.key && s.value).map(s => [s.key, s.value]))
  console.log('Saving product:', form.value)
  showModal.value = false
  resetForm()
}

function resetForm() {
  form.value = {
    name: '',
    slug: '',
    sku: '',
    category_id: null,
    description: '',
    price: 0,
    promo_price: null,
    stock: 0,
    gallery: [],
    status: 'draft',
    is_featured: false
  }
  formSpecs.value = []
  editingId.value = null
}

function getStatusClass(status) {
  const classes = {
    draft: 'bg-gray-100 text-gray-800 border border-gray-300',
    published: 'bg-black text-white',
    best_seller: 'bg-yellow-100 text-yellow-800 border border-yellow-300',
    coming_soon: 'bg-blue-100 text-blue-800 border border-blue-300',
    out_of_stock: 'bg-red-100 text-red-800 border border-red-300'
  }
  return classes[status] || 'bg-gray-100 text-gray-800 border border-gray-300'
}
</script>