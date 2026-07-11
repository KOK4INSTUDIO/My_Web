<template>
  <div>
    <!-- Auto Carousel Section (Full Width) -->
    <section class="relative bg-white overflow-hidden">
      <div 
        class="aspect-[21/9] relative overflow-hidden"
      >
        <!-- Carousel Slides -->
        <div 
          class="flex h-full transition-transform duration-500 ease-out"
          :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
        >
          <div 
            v-for="(slide, idx) in carouselSlides" 
            :key="idx"
            class="min-w-full h-full relative"
          >
            <template v-if="slide.endsWith('.mp4')">
              <video 
                class="absolute inset-0 w-full h-full object-cover object-center"
                :src="slide"
                autoplay
                muted
                playsinline
                loop
                crossorigin="anonymous"
              ></video>
            </template>
            <template v-else>
              <div 
                class="absolute inset-0 w-full h-full bg-cover bg-center"
                :style="{ backgroundImage: `url(${slide})` }"
              ></div>
            </template>
            <!-- Gradient Overlay -->
            <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent pointer-events-none"></div>
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
            <span class="font-display text-3xl font-bold text-accent-dark">KOK41STUDIO™</span>
          </div>
          <p class="text-primary-600 text-sm font-medium uppercase tracking-wider mb-4">MAKE IT YOURS</p>
          <h1 class="font-display text-5xl md:text-6xl font-bold text-accent-dark mb-6">
            Mari Berkolaborasi
          </h1>
          <p class="text-accent-gray text-lg mb-10 max-w-2xl mx-auto leading-relaxed">
            Jangan hanya memakai produk yang sama dengan orang lain. Tambahkan sentuhan pribadi melalui layanan custom KOK41STUDIO™.

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

    <!-- Footer -->
    <footer class="py-16 md:py-20 bg-primary-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-16">
          <!-- Payment Method -->
          <div class="text-center">
            <h2 class="font-display text-lg md:text-xl font-bold text-accent-dark mb-6 tracking-wide">Payment Method</h2>
            <div class="flex flex-wrap justify-center items-center gap-4 md:gap-6">
              <img src="/asset/qris.png" alt="Qris" class="h-8 md:h-10 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
              <img src="/asset/mandiri.png" alt="Mandiri" class="h-8 md:h-10 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
              <img src="/asset/bca.png" alt="BCA" class="h-8 md:h-10 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
              <img src="/asset/visa.png" alt="VISA" class="h-8 md:h-10 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
            </div>
          </div>
          
          <!-- Shipment Method -->
          <div class="text-center">
            <h2 class="font-display text-lg md:text-xl font-bold text-accent-dark mb-6 tracking-wide">Shipment Method</h2>
            <div class="flex flex-wrap justify-center items-center gap-4 md:gap-6">
              <img src="/asset/j&t.png" alt="J&T Express" class="h-10 md:h-12 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
              <img src="/asset/jne.png" alt="JNE Express" class="h-10 md:h-12 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity" style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);">
            </div>
          </div>
        </div>
        <div class="mt-12 pt-8 border-t border-gray-200 text-center">
          <p class="text-gray-500 text-sm">
            © 2026 KOK41STUDIO. All rights reserved.
          </p>
        </div>
      </div>
    </footer>

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
  '/asset/video.mp4',
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