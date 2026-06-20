<template>
  <div>
    <!-- Auto Carousel Section (Full Width) -->
    <section class="relative bg-white overflow-hidden">
      <div 
        class="aspect-[21/9] relative overflow-hidden"
      >
        <!-- Carousel Images -->
        <div 
          class="flex h-full transition-transform duration-500 ease-out"
          :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
        >
          <div 
            v-for="(slide, idx) in carouselSlides" 
            :key="idx"
            class="min-w-full h-full bg-cover bg-center"
            :style="{ backgroundImage: `url(${slide})` }"
          >
            <!-- Gradient Overlay -->
            <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent"></div>
          </div>
        </div>

        <!-- Navigation Dots -->
        <div class="absolute bottom-6 left-1/2 transform -translate-x-1/2 flex gap-3">
    
        </div>
      </div>
    </section>

    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-primary-50 to-white py-16 md:py-24">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
          <div class="flex items-center justify-center gap-3 mb-8">
            <span class="font-display text-3xl font-bold text-accent-dark">KOK4INSTUDIO™</span>
          </div>
          <p class="text-primary-600 text-sm font-medium uppercase tracking-wider mb-4">MAKE IT YOURS</p>
          <h1 class="font-display text-5xl md:text-6xl font-bold text-accent-dark mb-6">
            Mari Berkolaborasi
          </h1>
          <p class="text-accent-gray text-lg mb-10 max-w-2xl mx-auto leading-relaxed">
            Jangan hanya memakai produk yang sama dengan orang lain. Tambahkan sentuhan pribadi melalui layanan custom KOK4INSTUDIO™.

Desain sendiri. Ekspresikan diri. Tampilkan identitasmu.
          </p>
        </div>
      </div>
    </section>

    <!-- Banners Section -->
    <section v-if="banners.length > 0" class="bg-white py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="space-y-4">
          <div v-for="banner in banners" :key="banner.id" v-if="banner.is_active" class="relative rounded-2xl overflow-hidden shadow-soft hover:shadow-red transition-all">
            <div
              class="aspect-[16/9] bg-primary-50 bg-cover bg-center"
              :style="{ backgroundImage: `url(${banner.image_url})` }"
            ></div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-6 md:p-10">
              <h3 v-if="banner.title" class="font-display text-2xl md:text-4xl font-bold text-white mb-2">{{ banner.title }}</h3>
              <p v-if="banner.description" class="text-white/90 mb-4 max-w-2xl">{{ banner.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Products Section -->
    <section class="py-16 md:py-24 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mb-12 text-center">
          <h2 class="font-display text-3xl md:text-4xl font-bold text-accent-dark mb-4">Goods & Essentials</h2>
          <p class="text-accent-gray max-w-2xl mx-auto">Art | Custom | Aftermarket</p>
        </div>

        <!-- Products Grid -->
        <div v-if="products.length > 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 md:gap-8">
          <div v-for="product in products" :key="product.id" class="group">
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


      </div>
    </section>

  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const banners = ref([])
const categories = ref([])
const currentSlide = ref(0)
const carouselSlides = ref([
  '/asset/Page01.png',
])
let carouselInterval = null

// Helper functions
function getThumbnailUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.thumbnail || galleryItem?.display || ''
}

function getDisplayUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.display || galleryItem?.thumbnail || ''
}

onMounted(async () => {
  await loadCategories()
  await loadProducts()
  await loadBanners()
  
  // Auto slide every 3 seconds
  carouselInterval = setInterval(() => {
    currentSlide.value = (currentSlide.value + 1) % carouselSlides.value.length
  }, 3000)
})

onUnmounted(() => {
  if (carouselInterval) {
    clearInterval(carouselInterval)
  }
})

async function loadCategories() {
  const { data } = await supabase
    .from('categories')
    .select('*')
    .order('name', { ascending: true })
  
  categories.value = data || []
}

async function loadBanners() {
  const localBanners = localStorage.getItem('kok4ins_banners')
  if (localBanners) {
    banners.value = JSON.parse(localBanners)
  }
  try {
    const { data, error: fetchError } = await supabase
      .from('banners')
      .select('*')
      .order('sort_order', { ascending: true })
    if (!fetchError && data && data.length > 0) {
      banners.value = data
    }
  } catch (err) {
    console.warn('Supabase not available, using localStorage')
  }
}

async function loadProducts() {
  try {
    const { data } = await supabase
      .from('products')
      .select('*')
      .eq('status', 'published')
      .order('created_at', { ascending: false })

    const productsWithCategories = (data || []).map(product => ({
      ...product,
      category: categories.value.find(c => c.id === product.category_id)
    }))

    products.value = productsWithCategories
  } catch (err) {
    console.error('Error loading products:', err)
  }
}
</script>