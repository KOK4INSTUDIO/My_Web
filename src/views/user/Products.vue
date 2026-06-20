<template>
  <div class="py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="mb-12 text-center">
        <h1 class="font-display text-3xl md:text-4xl font-bold text-accent-dark mb-4">Goods & Essentials</h1>
        <p class="text-accent-gray max-w-2xl mx-auto">Art | Custom | Aftermarket</p>
      </div>

      <!-- Filters -->
      <div class="flex flex-col md:flex-row gap-4 mb-10">
        <input 
          v-model="searchQuery"
          type="text" 
          placeholder="Cari produk..."
          class="flex-1 px-5 py-3 border border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-colors bg-white"
        >
        <select v-model="filterCategory" class="px-5 py-3 border border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-colors bg-white">
          <option value="">Semua Kategori</option>
          <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
        </select>
      </div>

      <!-- Products Grid -->
      <div v-if="filteredProducts.length > 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 md:gap-8">
        <div v-for="product in filteredProducts" :key="product.id" class="group">
          <router-link :to="`/home/product/${product.slug}`" class="block">
            <div class="aspect-square bg-white border border-primary-100 rounded-xl mb-4 overflow-hidden shadow-soft group-hover:shadow-red transition-all">
              <img
                v-if="product.gallery && product.gallery[0]"
                :src="getThumbnailUrl(product.gallery[0])"
                :alt="product.name"
                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                loading="lazy"
              >
              <div v-else class="w-full h-full flex items-center justify-center">
                <span class="material-icons-round text-6xl text-gray-300">image</span>
              </div>
            </div>
            <p class="text-accent-gray text-xs mb-1">{{ product.category ? product.category.name : 'Aksesori' }}</p>
            <h3 class="font-medium text-accent-dark mb-1">{{ product.name }}</h3>
            <div class="flex items-center gap-2">
              <p class="text-primary-600 font-bold">
                Rp {{ (product.promo_price || product.price).toLocaleString() }}
              </p>
              <p v-if="product.promo_price" class="text-accent-gray text-sm line-through">
                Rp {{ product.price.toLocaleString() }}
              </p>
            </div>
          </router-link>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-16">
        <span class="material-icons-round text-6xl mb-4 block text-gray-300">search_off</span>
        <p class="text-accent-gray">Produk tidak ditemukan</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const categories = ref([])
const searchQuery = ref('')
const filterCategory = ref('')

// Helper functions
function getThumbnailUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.thumbnail || galleryItem?.display || ''
}

function getDisplayUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.display || galleryItem?.thumbnail || ''
}

const filteredProducts = computed(() => {
  let filtered = products.value
  if (searchQuery.value) {
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }
  if (filterCategory.value) {
    filtered = filtered.filter(p => p.category_id === filterCategory.value)
  }
  return filtered
})

onMounted(async () => {
  await loadCategories()
  await loadProducts()
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
    .eq('status', 'published')
    .order('created_at', { ascending: false })
  
  products.value = (data || []).map(product => ({
    ...product,
    category: categories.value.find(c => c.id === product.category_id)
  }))
}

// Add this to refresh products when needed
const refreshProducts = async () => {
  await loadProducts()
}
</script>
