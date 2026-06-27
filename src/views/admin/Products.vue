<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-dark">
        {{ currentCategoryName ? `Products - ${currentCategoryName}` : 'Products' }}
      </h3>
      <button @click="openAddModal" class="flex items-center justify-center gap-2 px-5 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-medium hover:from-primary-700 hover:to-primary-800 transition-all shadow-red text-sm rounded-xl">
        <span class="material-icons-round text-lg">add</span>
        Add Product
      </button>
    </div>

    <!-- Global Error -->
    <div v-if="error && !showModal" class="p-4 bg-red-100 border border-red-300 text-red-700 rounded-xl">
      {{ error }}
    </div>

    <!-- Global Success -->
    <div v-if="success && !showModal" class="p-4 bg-green-100 border border-green-300 text-green-700 rounded-xl">
      {{ success }}
    </div>

    <!-- Filter & Search -->
    <div class="flex flex-col md:flex-row gap-3">
      <input 
        v-model="searchQuery"
        type="text" 
        placeholder="Search products..."
        class="flex-1 min-w-48 px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl"
      />
      <select v-model="filterStatus" class="px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm bg-white rounded-xl">
        <option value="">All Status</option>
        <option value="draft">Draft</option>
        <option value="published">Published</option>
        <option value="best_seller">Best Seller</option>
        <option value="coming_soon">Coming Soon</option>
        <option value="out_of_stock">Out of Stock</option>
      </select>
      <select v-model="filterCategory" class="px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm bg-white rounded-xl">
        <option value="">All Categories</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>
    </div>

    <!-- Products Table -->
    <div class="bg-white border-2 border-primary-100 rounded-2xl shadow-soft overflow-x-auto">
      <table class="w-full" style="min-width: 700px;">
        <thead>
          <tr class="bg-primary-50 border-b border-primary-100">
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700"></th>
            <th class="px-5 py-4 text-left text-xs font-bold text-accent-dark">Product</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700 hidden md:table-cell">SKU</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-gray-700 hidden md:table-cell">Category</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-accent-dark">Price</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-accent-dark">Stock</th>
            <th class="px-5 py-4 text-left text-xs font-bold text-accent-dark">Status</th>
            <th class="px-5 py-4 text-right text-xs font-bold text-accent-dark">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr v-for="product in filteredProducts" :key="product.id" class="hover:bg-primary-50 transition-colors">
            <td class="px-5 py-4">
              <div class="w-10 h-10 bg-primary-50 border border-primary-100 rounded-xl flex items-center justify-center overflow-hidden">
                <span v-if="product.gallery && product.gallery[0]" class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: 'url(' + getThumbnailUrl(product.gallery[0]) + ')' }"></span>
                <span v-else class="material-icons-round text-gray-400 text-base">image</span>
              </div>
            </td>
            <td class="px-5 py-4">
              <p class="font-medium text-accent-dark text-sm">{{ product.name }}</p>
              <p class="text-xs text-gray-500 hidden md:block">{{ product.slug }}</p>
            </td>
            <td class="px-5 py-4 text-gray-500 font-mono text-xs">{{ product.sku || '-' }}</td>
            <td class="px-5 py-4 text-gray-600 text-xs hidden md:table-cell">{{ product.category ? product.category.name : '-' }}</td>
            <td class="px-5 py-4">
              <p class="text-primary-600 font-bold text-sm">Rp {{ (product.promo_price || product.price).toLocaleString() }}</p>
              <p v-if="product.promo_price" class="text-gray-400 text-xs line-through hidden md:block">Rp {{ product.price.toLocaleString() }}</p>
            </td>
            <td class="px-5 py-4 text-sm" :class="{ 'text-primary-600 font-bold': product.stock < 10 }">
              {{ product.stock }}
            </td>
            <td class="px-5 py-4">
              <span class="px-2.5 py-1 text-[10px] font-bold rounded-full" :class="getStatusClass(product.status)">
                {{ product.status }}
              </span>
            </td>
            <td class="px-5 py-4 text-right">
              <div class="flex items-center justify-end gap-2">
                <button @click="editProduct(product)" class="text-gray-500 hover:text-primary-600 p-1.5 rounded-xl hover:bg-primary-50 transition-all">
                  <span class="material-icons-round text-lg">edit</span>
                </button>
                <button @click="deleteProduct(product.id)" class="text-primary-600 hover:text-primary-700 p-1.5 rounded-xl hover:bg-primary-50 transition-all">
                  <span class="material-icons-round text-lg">delete</span>
                </button>
              </div>
            </td>
          </tr>
          <tr v-if="filteredProducts.length === 0">
            <td colspan="8" class="px-6 py-12 text-center">
              <span class="material-icons-round text-5xl mb-3 block text-gray-300">inventory</span>
              <p class="text-gray-500 text-sm">No products found. Add your first product!</p>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Add/Edit Product Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black/50 flex items-start justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-3xl w-full my-4 rounded-2xl border-2 border-primary-100 shadow-red overflow-hidden max-h-[90vh] flex flex-col">
        <div class="p-5 border-b border-primary-100 flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-accent-dark flex items-center gap-2">
            <span class="material-icons-round text-primary-600">inventory_2</span>
            {{ editingId ? 'Edit Product' : 'Add Product' }}
          </h3>
          <button @click="showModal = false" class="text-gray-400 hover:text-primary-600 hover:bg-primary-50 p-1.5 rounded-full transition-all">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        
        <div class="flex-1 overflow-y-auto">
          <!-- Error Message -->
          <div v-if="error" class="mx-5 mt-4 p-3 bg-red-100 border border-red-300 text-red-700 rounded-xl">
            {{ error }}
          </div>
          
          <!-- Success Message -->
          <div v-if="success" class="mx-5 mt-4 p-3 bg-green-100 border border-green-300 text-green-700 rounded-xl">
            {{ success }}
          </div>
          
          <form @submit.prevent="saveProduct" class="p-5 space-y-5">
          <!-- Basic Info -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Basic Information</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div class="md:col-span-2">
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Product Name *</label>
                <input v-model="form.name" type="text" required @input="generateSlug" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
              <div class="md:col-span-2">
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Slug *</label>
                <input v-model="form.slug" type="text" required class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">SKU (auto)</label>
                <input v-model="form.sku" type="text" class="w-full px-4 py-2.5 border-2 border-gray-200 bg-primary-50 text-gray-500 text-sm rounded-xl" readonly />
              </div>
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Category</label>
                <select v-model="form.category_id" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm bg-white rounded-xl">
                  <option :value="null">Select category...</option>
                  <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                </select>
              </div>
            </div>
            <div>
              <label class="block text-xs font-bold text-gray-700 mb-1.5">Description</label>
              <textarea v-model="form.description" rows="2" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
            </div>
          </div>

          <!-- Pricing -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Pricing & Stock</h4>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Price *</label>
                <input v-model.number="form.price" type="number" required min="0" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Promo Price</label>
                <input v-model.number="form.promo_price" type="number" min="0" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Stock *</label>
                <input v-model.number="form.stock" type="number" required min="0" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
            </div>
          </div>

          <!-- Gallery -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Gallery</h4>
            <div class="grid grid-cols-5 md:grid-cols-6 gap-2">
              <div v-for="(img, idx) in form.gallery" :key="idx" class="aspect-square bg-primary-50 border-2 border-primary-100 rounded-xl overflow-hidden relative group">
                <div class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: 'url(' + getThumbnailUrl(img) + ')' }"></div>
                <button type="button" @click="form.gallery.splice(idx, 1)" class="absolute top-1.5 right-1.5 w-6 h-6 bg-primary-600 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all">
                  <span class="material-icons-round text-sm">close</span>
                </button>
              </div>
              <label class="aspect-square border-2 border-dashed border-primary-200 rounded-xl flex items-center justify-center cursor-pointer hover:border-primary-500 hover:bg-primary-50 transition-all">
                <span class="material-icons-round text-primary-400 text-2xl">add_photo_alternate</span>
                <input type="file" accept="image/*" @change="addGalleryImage" class="hidden" />
              </label>
            </div>
          </div>

          <!-- Product Variants -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Varian Produk</h4>
            
            <!-- Add Variant Type Buttons -->
            <div class="flex flex-wrap gap-2">
              <button
                v-for="vt in variantTypes"
                :key="vt.key"
                type="button"
                @click="addVariantType(vt.key)"
                :disabled="form.variants.some(v => v.type === vt.key)"
                class="flex items-center gap-2 px-3 py-2 border border-primary-200 rounded-lg text-xs font-medium text-accent-gray hover:bg-primary-50 hover:text-primary-600 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span class="material-icons-round text-sm">{{ vt.icon }}</span>
                Tambah {{ vt.name }}
              </button>
            </div>

            <!-- Variant Type Sections -->
            <div v-for="variant in form.variants" :key="variant.type" class="bg-primary-50 p-4 rounded-xl border border-primary-100">
              <div class="flex items-center justify-between mb-3">
                <h5 class="text-sm font-bold text-accent-dark flex items-center gap-2">
                  <span class="material-icons-round text-primary-600 text-sm">
                    {{ variantTypes.find(vt => vt.key === variant.type)?.icon || 'inventory' }}
                  </span>
                  {{ variantTypes.find(vt => vt.key === variant.type)?.name }}
                </h5>
                <button
                  type="button"
                  @click="removeVariantType(variant.type)"
                  class="text-red-500 hover:text-red-600 p-1 rounded transition-colors"
                >
                  <span class="material-icons-round text-sm">delete</span>
                </button>
              </div>

              <div class="space-y-2">
                <div v-for="(option, idx) in variant.options" :key="idx" class="flex items-center gap-2">
                  <input
                    v-model="variant.options[idx]"
                    type="text"
                    :placeholder="`Nama ${variantTypes.find(vt => vt.key === variant.type)?.name.toLowerCase()}...`"
                    class="flex-1 px-3 py-2 border border-primary-200 bg-white rounded-lg text-sm focus:outline-none focus:border-primary-500 transition-colors"
                  />
                  <button
                    v-if="variant.options.length > 1"
                    type="button"
                    @click="removeVariantOption(variant.type, idx)"
                    class="text-red-500 hover:text-red-600 p-1 rounded transition-colors"
                  >
                    <span class="material-icons-round text-sm">close</span>
                  </button>
                </div>
              </div>

              <button
                type="button"
                @click="addVariantOption(variant.type)"
                class="mt-3 flex items-center gap-1.5 text-primary-600 text-xs font-medium hover:text-primary-700 transition-colors"
              >
                <span class="material-icons-round text-sm">add</span>
                Tambah Opsi
              </button>
            </div>
          </div>

          <!-- Specifications -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Spesifikasi</h4>
            
            <!-- Spec Items -->
            <div class="space-y-3">
              <div v-for="(spec, idx) in form.specifications" :key="idx" class="grid grid-cols-2 gap-3">
                <input
                  v-model="spec.key"
                  type="text"
                  placeholder="Nama spesifikasi (misal: Brand)"
                  class="px-3 py-2 border border-primary-200 bg-white rounded-lg text-sm focus:outline-none focus:border-primary-500 transition-colors"
                />
                <div class="flex gap-2">
                  <input
                    v-model="spec.value"
                    type="text"
                    placeholder="Nilai spesifikasi"
                    class="flex-1 px-3 py-2 border border-primary-200 bg-white rounded-lg text-sm focus:outline-none focus:border-primary-500 transition-colors"
                  />
                  <button
                    type="button"
                    @click="removeSpec(idx)"
                    class="text-red-500 hover:text-red-600 p-1 rounded transition-colors"
                  >
                    <span class="material-icons-round text-sm">delete</span>
                  </button>
                </div>
              </div>
            </div>
            
            <!-- Add Spec Button -->
            <button
              type="button"
              @click="addSpec()"
              class="flex items-center gap-2 px-4 py-2 border border-primary-200 text-primary-600 text-sm font-medium hover:bg-primary-50 transition-all rounded-lg"
            >
              <span class="material-icons-round text-sm">add</span>
              Tambah Spesifikasi
            </button>
          </div>

          <!-- Social/Shop Links -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Link Toko & Sosial</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">TikTok URL</label>
                <input v-model="form.tiktok_url" type="url" placeholder="https://tiktok.com/..." class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Shopee URL</label>
                <input v-model="form.shopee_url" type="url" placeholder="https://shopee.co.id/..." class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm rounded-xl" />
              </div>
            </div>
          </div>

          <!-- Status -->
          <div class="space-y-3">
            <h4 class="font-bold text-accent-dark border-l-2 border-primary-600 pl-3 text-sm">Status</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-bold text-gray-700 mb-1.5">Status</label>
                <select v-model="form.status" class="w-full px-4 py-2.5 border-2 border-gray-200 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all text-sm bg-white rounded-xl">
                  <option value="draft">Draft</option>
                  <option value="published">Published</option>
                  <option value="best_seller">Best Seller</option>
                  <option value="coming_soon">Coming Soon</option>
                  <option value="out_of_stock">Out of Stock</option>
                </select>
              </div>
              <div class="flex items-end">
                <label class="flex items-center gap-2 cursor-pointer">
                  <input v-model="form.is_featured" type="checkbox" class="w-4 h-4 rounded text-primary-600 focus:ring-primary-600 border-gray-300" />
                  <span class="text-xs font-bold text-gray-700">Featured</span>
                </label>
              </div>
            </div>
          </div>

          <div class="flex gap-3 pt-4 border-t border-primary-100">
            <button type="button" @click="showModal = false" class="flex-1 px-5 py-2.5 border-2 border-primary-200 text-accent-dark font-medium hover:bg-primary-50 transition-all text-sm rounded-xl" :disabled="loading">Cancel</button>
            <button type="submit" class="flex-1 px-5 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-medium hover:from-primary-700 hover:to-primary-800 transition-all text-sm rounded-xl shadow-red flex items-center justify-center gap-2" :disabled="loading">
              <span v-if="loading" class="material-icons-round animate-spin">refresh</span>
              <span v-else class="material-icons-round">{{ editingId ? 'save' : 'add' }}</span>
              {{ loading ? 'Saving...' : (editingId ? 'Update' : 'Add') }}
            </button>
          </div>
        </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'

const route = useRoute()

const products = ref([])
const categories = ref([])
const showModal = ref(false)
const editingId = ref(null)
const searchQuery = ref('')
const filterStatus = ref('')
const filterCategory = ref('')
const loading = ref(false)
const error = ref(null)
const success = ref(null)

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
  is_featured: false,
  variants: [],
  specifications: [],
  tiktok_url: '',
  shopee_url: ''
})

const variantTypes = ref([
  { key: 'warna', name: 'Warna', icon: 'palette' },
  { key: 'teks', name: 'Teks', icon: 'title' },
  { key: 'ukuran', name: 'Ukuran', icon: 'straighten' }
])

function addVariantType(variantTypeKey) {
  const existing = form.value.variants.find(v => v.type === variantTypeKey)
  if (!existing) {
    form.value.variants.push({
      type: variantTypeKey,
      options: ['']
    })
  }
}

function removeVariantType(variantTypeKey) {
  const index = form.value.variants.findIndex(v => v.type === variantTypeKey)
  if (index !== -1) {
    form.value.variants.splice(index, 1)
  }
}

function addVariantOption(variantTypeKey) {
  const variant = form.value.variants.find(v => v.type === variantTypeKey)
  if (variant) {
    variant.options.push('')
  }
}

function removeVariantOption(variantTypeKey, index) {
  const variant = form.value.variants.find(v => v.type === variantTypeKey)
  if (variant) {
    variant.options.splice(index, 1)
  }
}

function addSpec() {
  form.value.specifications.push({ key: '', value: '' })
}

function removeSpec(index) {
  form.value.specifications.splice(index, 1)
}

const filteredProducts = computed(() => {
  let filtered = products.value
  if (searchQuery.value) {
    filtered = filtered.filter(p => {
      const nameMatch = p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
      const skuMatch = p.sku && p.sku.toLowerCase().includes(searchQuery.value.toLowerCase())
      return nameMatch || skuMatch
    })
  }
  if (filterStatus.value) {
    filtered = filtered.filter(p => p.status === filterStatus.value)
  }
  if (filterCategory.value) {
    filtered = filtered.filter(p => p.category_id === filterCategory.value)
  }
  return filtered
})

const currentCategoryName = computed(() => {
  if (filterCategory.value) {
    const cat = categories.value.find(c => c.id === filterCategory.value)
    return cat ? cat.name : ''
  }
  return ''
})

onMounted(async () => {
  await loadCategories()
  await loadProducts()
  
  // Set filter category from route params if available
  if (route.params.categoryId) {
    filterCategory.value = route.params.categoryId
  }
})

// Watch for route param changes
watch(() => route.params.categoryId, (newCategoryId) => {
  if (newCategoryId) {
    filterCategory.value = newCategoryId
  }
})

async function loadCategories() {
  const { data } = await supabase
    .from('categories')
    .select('*')
    .order('name', { ascending: true })
  
  categories.value = data || []
}

async function loadProducts() {
  const { data } = await supabase
    .from('products')
    .select('*')
    .order('created_at', { ascending: false })
  
  products.value = (data || []).map(product => ({
    ...product,
    category: categories.value.find(c => c.id === product.category_id)
  }))
}

async function generateSlug() {
  if (form.value.name) {
    let baseSlug = form.value.name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')
    let newSlug = baseSlug
    let counter = 1
    
    // Cek apakah slug sudah ada (kecuali untuk produk yang sedang diedit)
    while (true) {
      const { data } = await supabase
        .from('products')
        .select('id, slug')
        .eq('slug', newSlug)
        .neq('id', editingId.value || '') // Skip produk yang sedang diedit
      
      if (!data || data.length === 0) break
      
      counter++
      newSlug = `${baseSlug}-${counter}`
    }
    
    form.value.slug = newSlug
    form.value.sku = 'PRD-' + Date.now().toString(36).toUpperCase()
  }
}

// Image processing utility functions
async function processImage(file, maxWidth, maxHeight, quality = 0.8) {
  return new Promise((resolve) => {
    const img = new Image()
    img.onload = () => {
      // Calculate new dimensions while preserving aspect ratio
      let { width, height } = img
      if (width > maxWidth || height > maxHeight) {
        const ratio = Math.min(maxWidth / width, maxHeight / height)
        width = Math.round(width * ratio)
        height = Math.round(height * ratio)
      }

      // Create canvas for resizing
      const canvas = document.createElement('canvas')
      canvas.width = width
      canvas.height = height
      
      // Draw image on canvas
      const ctx = canvas.getContext('2d')
      ctx.imageSmoothingEnabled = true
      ctx.imageSmoothingQuality = 'high'
      ctx.drawImage(img, 0, 0, width, height)
      
      // Convert to WebP
      canvas.toBlob(
        (blob) => {
          const reader = new FileReader()
          reader.onload = (e) => resolve(e.target.result)
          reader.readAsDataURL(blob)
        },
        'image/webp',
        quality
      )
    }
    img.src = URL.createObjectURL(file)
  })
}

async function addGalleryImage(event) {
  const files = event.target.files
  if (files && files.length > 0) {
    const file = files[0]
    
    // Process and save as optimized WebP (for compatibility, just save display version for now)
    const display = await processImage(file, 1200, 1200, 0.8)
    
    // Store as string (compatible with TEXT[] schema)
    form.value.gallery.push(display)
  }
  // Reset input
  event.target.value = ''
}

// Helper functions for backward compatibility
function getThumbnailUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.thumbnail || galleryItem?.display || ''
}

function getDisplayUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.display || galleryItem?.thumbnail || ''
}

async function saveProduct() {
  loading.value = true
  error.value = null
  success.value = null
  
  try {
    // Pastikan slug selalu ada dan unique sebelum menyimpan
    if (!form.value.slug || form.value.slug === '') {
      await generateSlug()
    } else {
      // Cek lagi apakah slug sudah ada
      const { data } = await supabase
        .from('products')
        .select('id, slug')
        .eq('slug', form.value.slug)
        .neq('id', editingId.value || '')
      
      if (data && data.length > 0) {
        await generateSlug()
      }
    }
    
    // Filter specifications to only include those with both key and value
    const validSpecifications = form.value.specifications.filter(spec => spec.key && spec.value)
    
    // Try to save with all fields first
    const productData = {
      name: form.value.name,
      slug: form.value.slug,
      sku: form.value.sku || `PRD-${Date.now().toString(36).toUpperCase()}`,
      category_id: form.value.category_id || null,
      description: form.value.description,
      price: form.value.price,
      promo_price: form.value.promo_price,
      stock: form.value.stock,
      gallery: form.value.gallery,
      status: form.value.status,
      is_featured: form.value.is_featured,
      specifications: validSpecifications.length > 0 ? validSpecifications : [],
      tiktok_url: form.value.tiktok_url || '',
      shopee_url: form.value.shopee_url || ''
    }
    
    // Only add variants if there are any
    if (form.value.variants && form.value.variants.length > 0) {
      productData.variants = form.value.variants
    }
    
    if (editingId.value) {
      let { error: updateError } = await supabase
        .from('products')
        .update(productData)
        .eq('id', editingId.value)
      
      // If error is about missing variants column, try without it
      if (updateError && (updateError.message?.includes('variants') || updateError.code === 'PGRST116')) {
        const basicData = { ...productData }
        delete basicData.variants
        ;({ error: updateError } = await supabase
          .from('products')
          .update(basicData)
          .eq('id', editingId.value))
      }
      
      if (updateError) throw updateError
      success.value = 'Produk berhasil diupdate!'
    } else {
      let { error: insertError } = await supabase
        .from('products')
        .insert(productData)
      
      // If error is about missing variants column, try without it
      if (insertError && (insertError.message?.includes('variants') || insertError.code === 'PGRST116')) {
        const basicData = { ...productData }
        delete basicData.variants
        ;({ error: insertError } = await supabase
          .from('products')
          .insert(basicData))
      }
      
      if (insertError) throw insertError
      success.value = 'Produk berhasil ditambahkan!'
    }
    
    await loadProducts()
    
    // Tutup modal setelah delay agar user bisa melihat success message
    setTimeout(() => {
      showModal.value = false
      resetForm()
    }, 1000)
    
  } catch (err) {
    console.error('Error saving product:', err)
    error.value = err.message || 'Terjadi kesalahan saat menyimpan produk'
  } finally {
    loading.value = false
  }
}

async function deleteProduct(id) {
  if (confirm('Delete this product?')) {
    await supabase.from('products').delete().eq('id', id)
    await loadProducts()
  }
}

function editProduct(product) {
  editingId.value = product.id
  error.value = null
  success.value = null
  form.value = {
    name: product.name,
    slug: product.slug,
    sku: product.sku,
    category_id: product.category_id,
    description: product.description,
    price: product.price,
    promo_price: product.promo_price,
    stock: product.stock,
    gallery: product.gallery || [],
    status: product.status,
    is_featured: product.is_featured,
    variants: product.variants || [],
    specifications: product.specifications || [],
    tiktok_url: product.tiktok_url || '',
    shopee_url: product.shopee_url || ''
  }
  showModal.value = true
}

function resetForm() {
  error.value = null
  success.value = null
  loading.value = false
  form.value = {
    name: '',
    slug: '',
    sku: '',
    category_id: filterCategory.value || null,
    description: '',
    price: 0,
    promo_price: null,
    stock: 0,
    gallery: [],
    status: 'draft',
    is_featured: false,
    variants: [],
    specifications: [],
    tiktok_url: '',
    shopee_url: ''
  }
  editingId.value = null
}

// Reset form dan error saat membuka modal tambah produk
function openAddModal() {
  resetForm()
  showModal.value = true
}

function getStatusClass(status) {
  const classes = {
    draft: 'bg-gray-100 text-gray-800',
    published: 'bg-primary-600 text-white',
    best_seller: 'bg-amber-100 text-amber-800',
    coming_soon: 'bg-blue-100 text-blue-800',
    out_of_stock: 'bg-primary-100 text-primary-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}
</script>
