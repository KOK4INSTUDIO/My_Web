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
            <img src="/asset/logo.png" alt="KOK4INSTUDIO" class="h-20 md:h-32 object-contain" />
          </div>
          <p class="text-primary-600 text-sm font-medium uppercase tracking-wider mb-4">MAKE IT YOURS</p>
          <h1 class="font-display text-5xl md:text-6xl font-bold text-accent-dark mb-6">
            Mari Berkolaborasi
          </h1>
          <p class="text-accent-gray text-lg mb-10 max-w-2xl mx-auto leading-relaxed">
            Jangan hanya memakai produk yang sama dengan orang lain. Tambahkan sentuhan pribadi melalui layanan custom KOK4INSTUDIO™.

Desain sendiri. Ekspresikan diri. Tampilkan identitasmu.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link to="/user/login" class="flex items-center justify-center gap-3 px-10 py-4 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-bold hover:from-primary-700 hover:to-primary-800 transition-all rounded-xl shadow-red hover:shadow-xl transform hover:-translate-y-0.5">
              <span class="material-icons-round">login</span>
              Masuk Sekarang
            </router-link>
            <router-link to="/user/register" class="flex items-center justify-center gap-3 px-10 py-4 border-2 border-primary-500 text-primary-700 font-bold hover:bg-primary-50 transition-all rounded-xl">
              <span class="material-icons-round">person_add</span>
              Daftar Gratis
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Photo Carousel Section -->
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-dark">Custom Goods</h2>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
          <div v-for="(photo, idx) in carouselPhotos" :key="idx" class="aspect-square bg-gray-100 overflow-hidden group rounded-xl border border-primary-100">
            <div
              class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-500"
              :style="{ backgroundImage: `url(${photo})` }"
            ></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Featured Products Section (Carousel) -->
    <section class="py-16 md:py-20 bg-primary-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-dark">Produk Kami</h2>
        </div>
        
        <div v-if="products.length > 0" class="relative">
          <!-- Carousel Container -->
          <div class="overflow-hidden">
            <div 
              class="flex transition-transform duration-500 ease-out"
              :style="{ transform: `translateX(-${currentProductSlide * 100}%)` }"
            >
              <!-- Each slide shows 4 products on lg, 2 on sm, 1 on xs -->
              <div v-for="slideIndex in totalProductSlides" :key="slideIndex" class="min-w-full">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8">
                  <router-link
                    v-for="product in getProductsForSlide(slideIndex - 1)"
                    :key="product.id"
                    to="/user/login"
                    class="group"
                  >
                    <div class="aspect-square bg-white border border-primary-100 rounded-xl mb-4 overflow-hidden shadow-soft group-hover:shadow-red transition-all">
                      <div
                        v-if="product.gallery?.[0]"
                        class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-300"
                        :style="{ backgroundImage: `url(${product.gallery[0]})` }"
                      ></div>
                      <span v-else class="w-full h-full flex items-center justify-center">
                        <span class="material-icons-round text-6xl text-gray-300">image</span>
                      </span>
                    </div>
                    <p class="text-accent-gray text-xs mb-1">{{ product.category?.name || 'Aksesori' }}</p>
                    <h3 class="font-medium text-accent-dark mb-1">{{ product.name }}</h3>
                    <div class="flex items-center gap-2">
                      <p class="text-primary-600 font-bold">
                        Rp {{ (product.promo_price || product.price)?.toLocaleString() }}
                      </p>
                      <p v-if="product.promo_price" class="text-accent-gray text-sm line-through">
                        Rp {{ product.price?.toLocaleString() }}
                      </p>
                    </div>
                  </router-link>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Navigation Buttons -->
          <button 
            v-if="totalProductSlides > 1"
            @click="prevProductSlide"
            class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-4 w-12 h-12 bg-white border border-primary-100 rounded-full shadow-soft flex items-center justify-center text-primary-600 hover:bg-primary-50 transition-all"
          >
            <span class="material-icons-round">arrow_back</span>
          </button>
          <button 
            v-if="totalProductSlides > 1"
            @click="nextProductSlide"
            class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-4 w-12 h-12 bg-white border border-primary-100 rounded-full shadow-soft flex items-center justify-center text-primary-600 hover:bg-primary-50 transition-all"
          >
            <span class="material-icons-round">arrow_forward</span>
          </button>
          
          <!-- Dots Navigation -->
          <div v-if="totalProductSlides > 1" class="flex justify-center gap-2 mt-8">
            <button
              v-for="i in totalProductSlides"
              :key="i"
              @click="currentProductSlide = i - 1"
              class="w-3 h-3 rounded-full transition-all"
              :class="currentProductSlide === i - 1 ? 'bg-primary-600' : 'bg-primary-200'"
            ></button>
          </div>
        </div>
        
        <div v-else class="text-center py-10">
          <span class="material-icons-round text-6xl text-primary-300 mb-4">shopping_bag</span>
          <p class="text-accent-gray">Produk akan segera tersedia!</p>
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

    <!-- About Section -->
    <section class="py-16 md:py-20 bg-white">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-dark mb-6">{{ aboutData.title }}</h2>
        <p class="text-accent-gray text-lg leading-relaxed mb-6" v-if="aboutData.content1">
          {{ aboutData.content1 }}
        </p>
        <p class="text-accent-gray text-lg leading-relaxed mb-6" v-if="aboutData.content2">
          {{ aboutData.content2 }}
        </p>
        <p class="text-accent-gray text-lg leading-relaxed" v-if="aboutData.content3">
          {{ aboutData.content3 }}
        </p>
      </div>
    </section>



    <!-- Footer / CTA -->
    <section class="bg-gradient-to-r from-primary-600 to-primary-700 text-white py-16 md:py-20 shadow-red">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div class="flex items-center justify-center gap-3 mb-8">
          <img src="/asset/logo.png" alt="KOK4INSTUDIO" class="h-16 md:h-24 object-contain invert" />
        </div>
        <h2 class="font-display text-3xl md:text-4xl font-bold mb-6">Siap Memulai?</h2>
        <p class="text-white/80 mb-8">Daftar sekarang dan temukan koleksi terbaik untuk gaya Anda!</p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center">
          <router-link to="/user/register" class="flex items-center justify-center gap-3 px-8 py-3 bg-white text-primary-700 font-bold hover:bg-gray-100 transition-all rounded-xl">
            <span class="material-icons-round">person_add</span>
            Daftar Sekarang
          </router-link>
          <router-link to="/user/login" class="flex items-center justify-center gap-3 px-8 py-3 border-2 border-white text-white font-bold hover:bg-white/10 transition-all rounded-xl">
            <span class="material-icons-round">login</span>
            Masuk
          </router-link>
        </div>
      </div>
    </section>

    <!-- Payment & Shipment Methods Section -->
    <section class="py-16 md:py-20 bg-primary-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-16">
          <!-- Payment Method -->
          <div class="text-center">
            <h2 class="font-display text-lg md:text-xl font-bold text-accent-dark mb-6 tracking-wide">Payment Method</h2>
            <div class="flex flex-wrap justify-center items-center gap-4 md:gap-6">
              <img 
                src="/asset/qris.png" 
                alt="Qris" 
                class="h-5 md:h-7 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
              <img 
                src="/asset/mandiri.png" 
                alt="Mandiri" 
                class="h-5 md:h-7 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
              <img 
                src="/asset/bca.png" 
                alt="BCA" 
                class="h-5 md:h-7 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
              <img 
                src="/asset/visa.png" 
                alt="VISA" 
                class="h-5 md:h-7 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
            </div>
          </div>
          
          <!-- Shipment Method -->
          <div class="text-center">
            <h2 class="font-display text-lg md:text-xl font-bold text-accent-dark mb-6 tracking-wide">Shipment Method</h2>
            <div class="flex flex-wrap justify-center items-center gap-4 md:gap-6">
              <img 
                src="/asset/j&t.png" 
                alt="J&T Express" 
                class="h-6 md:h-8 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
              <img 
                src="/asset/jne.png" 
                alt="JNE Express" 
                class="h-6 md:h-8 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                style="filter: brightness(0) saturate(100%) invert(16%) sepia(88%) saturate(6395%) hue-rotate(353deg) brightness(92%) contrast(106%);"
              >
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const banners = ref([])
const currentSlide = ref(0)
const carouselSlides = ref([
  '/asset/Page01.png',
])
const currentProductSlide = ref(0)
const PRODUCTS_PER_SLIDE = 4
let carouselInterval = null

const categories = ref([
  { id: 1, name: 'Aksesoris', slug: 'aksesoris' },
  { id: 2, name: 'Fashion', slug: 'fashion' }
])
const aboutData = ref({
  title: 'Tentang KOK4INSTUDIO™',
  content1: 'KOK4INSTUDIO adalah brand fashion yang lahir dari semangat untuk terus berkarya dan menghadirkan produk berkualitas bagi setiap pelanggan. Kami baru memulai perjalanan di dunia fashion, namun kami memiliki komitmen yang kuat untuk menghasilkan berbagai produk custom yang dibuat dengan perhatian terhadap detail, kualitas, dan identitas yang khas.',
  content2: 'Setiap produk yang kami hadirkan dirancang untuk memberikan kenyamanan, nilai estetika, serta karakter yang dapat mewakili gaya dan kepribadian penggunanya. Kami percaya bahwa sebuah produk tidak hanya sekadar pakaian atau aksesori, tetapi juga menjadi bagian dari identitas dan ekspresi diri.',
  content3: 'Dengan mengutamakan kualitas bahan, proses produksi yang teliti, serta pelayanan terbaik, KOK4INSTUDIO terus berupaya berkembang dan menghadirkan karya-karya yang dapat dibanggakan. Terima kasih telah menjadi bagian dari perjalanan kami dalam menciptakan produk fashion yang autentik dan bernilai.'
})

const carouselPhotos = ref([
  '/asset/img001.png',
  '/asset/img002.png',
  '/asset/img003.jpeg',
  '/asset/img004.jpeg',
])

onMounted(async () => {
  await loadProducts()
  await loadAbout()
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

const totalProductSlides = computed(() => {
  return Math.ceil(products.value.length / PRODUCTS_PER_SLIDE) || 1
})

function getProductsForSlide(slideIndex) {
  const start = slideIndex * PRODUCTS_PER_SLIDE
  const end = start + PRODUCTS_PER_SLIDE
  return products.value.slice(start, end)
}

function nextProductSlide() {
  currentProductSlide.value = (currentProductSlide.value + 1) % totalProductSlides.value
}

function prevProductSlide() {
  currentProductSlide.value = (currentProductSlide.value - 1 + totalProductSlides.value) % totalProductSlides.value
}

async function loadAbout() {
  try {
    const { data } = await supabase
      .from('site_settings')
      .select('*')
      .eq('id', 'about_content')
      .single()

    if (data) {
      aboutData.value = data
    }
  } catch (error) {
    console.error('Error loading about content:', error)
  }
}
</script>