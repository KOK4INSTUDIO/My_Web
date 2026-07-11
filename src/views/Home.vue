<template>
  <div>
    <!-- Hero Section -->
    <section class="bg-accent-light py-16 md:py-24">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
          <p class="text-gray-500 text-sm font-medium uppercase tracking-wider mb-4">New Arrivals</p>
          <h1 class="font-display text-4xl md:text-6xl font-bold text-accent-black mb-6">
            Koleksi Terbaru 2026
          </h1>
          <p class="text-gray-600 text-lg mb-10 max-w-2xl mx-auto leading-relaxed">
            Temukan kacamata dan aksesori premium dengan desain modern dan kualitas terbaik untuk penampilan Anda sehari-hari.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link to="/products" class="inline-block px-10 py-4 bg-accent-black text-white font-bold hover:bg-accent-dark transition-colors">
              Belanja Sekarang
            </router-link>
            <router-link to="/auth" class="inline-block px-10 py-4 border border-accent-black text-accent-black font-bold hover:bg-accent-black hover:text-white transition-colors">
              Masuk / Daftar
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Photo Carousel Section -->
    <section class="py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-black">Our Moments</h2>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div v-for="(photo, idx) in carouselPhotos" :key="idx" class="aspect-square bg-gray-100 overflow-hidden group">
            <div
              class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-500"
              :style="{ backgroundImage: `url(${photo})` }"
            ></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Featured Products Section -->
    <section class="py-16 md:py-20 bg-gray-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col md:flex-row justify-between items-end mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-black">Produk Terlaris</h2>
          <router-link to="/products" class="text-accent-black font-medium text-sm hover:underline mt-4 md:mt-0">
            Lihat Semua →
          </router-link>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8">
          <div
            v-for="product in featuredProducts"
            :key="product.id"
            class="group"
          >
            <router-link :to="`/product/${product.slug}`" class="block">
              <div class="aspect-square bg-gray-100 mb-4 overflow-hidden">
                <div
                  v-if="product.gallery?.[0]"
                  class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-300"
                  :style="{ backgroundImage: `url(${product.gallery[0]})` }"
                ></div>
                <span v-else class="w-full h-full flex items-center justify-center">
                  <span class="material-icons-round text-6xl text-gray-300">image</span>
                </span>
              </div>
              <p class="text-gray-500 text-xs mb-1">{{ product.category?.name || 'Aksesori' }}</p>
              <h3 class="font-medium text-accent-black mb-1">{{ product.name }}</h3>
              <div class="flex items-center gap-2">
                <p class="text-accent-black font-bold">
                  Rp {{ (product.promo_price || product.price)?.toLocaleString() }}
                </p>
                <p v-if="product.promo_price" class="text-gray-400 text-sm line-through">
                  Rp {{ product.price?.toLocaleString() }}
                </p>
              </div>
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Design Photos Section -->
    <section class="py-16 md:py-20 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-black">Our Design Process</h2>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 md:gap-8">
          <div class="aspect-[4/3] bg-gray-100 overflow-hidden group">
            <div
              class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-500"
              style="background-image: url('https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')"
            ></div>
          </div>
          <div class="aspect-[4/3] bg-gray-100 overflow-hidden group">
            <div
              class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-500"
              style="background-image: url('https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80')"
            ></div>
          </div>
        </div>
      </div>
    </section>

    <!-- FAQ Section -->
    <section class="py-16 md:py-20 bg-gray-50">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-10">
          <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-black">Frequently Asked Questions</h2>
        </div>
        <div class="space-y-4">
          <div v-for="(faq, idx) in faqs" :key="idx" class="border border-gray-200 bg-white rounded-lg overflow-hidden">
            <button
              @click="toggleFaq(idx)"
              class="w-full px-6 py-5 text-left flex items-center justify-between hover:bg-gray-50 transition-colors"
            >
              <span class="font-medium text-accent-black">{{ faq.question }}</span>
              <span class="material-icons-round text-gray-500 transition-transform duration-300" :class="{ 'rotate-180': openFaq === idx }">
                expand_more
              </span>
            </button>
            <div
              v-show="openFaq === idx"
              class="px-6 pb-5 text-gray-600 text-sm leading-relaxed"
              v-transition
            >
              {{ faq.answer }}
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- About Section -->
    <section class="py-16 md:py-20 bg-white">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="font-display text-2xl md:text-3xl font-bold text-accent-black mb-6">{{ aboutData.title }}</h2>
        <p class="text-gray-600 text-lg leading-relaxed mb-6" v-if="aboutData.content1">
          {{ aboutData.content1 }}
        </p>
        <p class="text-gray-600 text-lg leading-relaxed mb-6" v-if="aboutData.content2">
          {{ aboutData.content2 }}
        </p>
        <p class="text-gray-600 text-lg leading-relaxed" v-if="aboutData.content3">
          {{ aboutData.content3 }}
        </p>
      </div>
    </section>

    <!-- Feature Section -->
    <section class="py-16 md:py-20 bg-gray-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8 text-center">
          <div class="p-4">
            <span class="material-icons-round text-5xl text-gray-400 mb-4">local_shipping</span>
            <h3 class="font-medium text-accent-black mb-2">Pengiriman Cepat</h3>
            <p class="text-gray-500 text-sm">Pengiriman ke seluruh Indonesia</p>
          </div>
          <div class="p-4">
            <span class="material-icons-round text-5xl text-gray-400 mb-4">verified</span>
            <h3 class="font-medium text-accent-black mb-2">Produk Asli</h3>
            <p class="text-gray-500 text-sm">Jaminan kualitas 100%</p>
          </div>
          <div class="p-4">
            <span class="material-icons-round text-5xl text-gray-400 mb-4">assignment_return</span>
            <h3 class="font-medium text-accent-black mb-2">Gratis Pengembalian</h3>
            <p class="text-gray-500 text-sm">Pengembalian dalam 30 hari</p>
          </div>
          <div class="p-4">
            <span class="material-icons-round text-5xl text-gray-400 mb-4">support_agent</span>
            <h3 class="font-medium text-accent-black mb-2">Layanan 24/7</h3>
            <p class="text-gray-500 text-sm">Siap membantu Anda kapan saja</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Contact CTA Section -->
    <section class="bg-accent-black text-white py-16 md:py-20">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="font-display text-3xl md:text-4xl font-bold mb-6">Hubungi Kami</h2>
        <p class="text-gray-400 mb-8">Ada pertanyaan? Kami siap membantu.</p>
        <router-link to="/contact" class="inline-block px-10 py-4 bg-white text-accent-black font-bold hover:bg-gray-100 transition-colors">
          Kontak Kami
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const products = ref([])
const featuredProducts = ref([])
const openFaq = ref(null)
const aboutData = ref({
  title: 'Tentang KOK41NSTUDIO™',
  content1: 'KOK41NSTUDIO™ adalah brand fashion yang lahir dari semangat untuk terus berkarya dan menghadirkan produk berkualitas bagi setiap pelanggan. Kami baru memulai perjalanan di dunia fashion, namun kami memiliki komitmen yang kuat untuk menghasilkan berbagai produk custom yang dibuat dengan perhatian terhadap detail, kualitas, dan identitas yang khas.',
  content2: 'Setiap produk yang kami hadirkan dirancang untuk memberikan kenyamanan, nilai estetika, serta karakter yang dapat mewakili gaya dan kepribadian penggunanya. Kami percaya bahwa sebuah produk tidak hanya sekadar pakaian atau aksesori, tetapi juga menjadi bagian dari identitas dan ekspresi diri.',
  content3: 'Dengan mengutamakan kualitas bahan, proses produksi yang teliti, serta pelayanan terbaik, KOK41NSTUDIO™ terus berupaya berkembang dan menghadirkan karya-karya yang dapat dibanggakan. Terima kasih telah menjadi bagian dari perjalanan kami dalam menciptakan produk fashion yang autentik dan bernilai.'
})

const carouselPhotos = ref([
  'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
  'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80'
])

const faqs = ref([
  {
    question: 'Berapa lama waktu pengiriman?',
    answer: 'Pengiriman memakan waktu 2-5 hari kerja tergantung lokasi Anda. Kami menggunakan jasa pengiriman terpercaya untuk memastikan produk sampai dengan aman.'
  },
  {
    question: 'Apakah bisa mengembalikan produk?',
    answer: 'Ya, Anda bisa mengembalikan produk dalam 30 hari setelah penerimaan dengan syarat produk dalam kondisi belum dipakai dan label masih lengkap.'
  },
  {
    question: 'Bagaimana cara merawat kacamata?',
    answer: 'Bersihkan lensa dengan kain microfiber yang lembut, hindari penggunaan bahan kimia keras. Simpan kacamata di tempat yang kering dan aman.'
  },
  {
    question: 'Apakah ada garansi produk?',
    answer: 'Kami memberikan garansi 6 bulan untuk kerusakan material. Garansi tidak termasuk kerusakan akibat penggunaan yang tidak wajar.'
  }
])

function toggleFaq(idx) {
  openFaq.value = openFaq.value === idx ? null : idx
}

onMounted(async () => {
  await loadProducts()
  await loadAbout()
})

async function loadProducts() {
  const { data } = await supabase
    .from('products')
    .select('*, category:categories(*)')
    .eq('status', 'published')
    .order('created_at', { ascending: false })
    .limit(8)
  
  products.value = data || []
  featuredProducts.value = data?.filter(p => p.is_featured).slice(0, 4) || data?.slice(0, 4) || []
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
