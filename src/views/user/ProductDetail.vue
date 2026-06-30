<template>
  <div v-if="product" class="py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <!-- Product Gallery -->
        <div>
          <!-- Main Image -->
          <div class="aspect-square bg-white border border-primary-100 mb-4 overflow-hidden rounded-xl shadow-soft">
            <img
              v-if="currentImage"
              :src="currentImage"
              :alt="product.name"
              class="w-full h-full object-cover"
            >
            <div v-else class="w-full h-full flex items-center justify-center">
              <span class="material-icons-round text-8xl text-gray-300">image</span>
            </div>
          </div>
          <!-- Thumbnail Gallery -->
          <div v-if="galleryImages.length > 0" class="grid grid-cols-4 gap-3">
            <div
              v-for="(img, idx) in galleryImages"
              :key="idx"
              @click="currentImage = getDisplayUrl(img)"
              class="aspect-square bg-white border-2 overflow-hidden rounded-xl cursor-pointer transition-all"
              :class="currentImage === getDisplayUrl(img) ? 'border-primary-600 shadow-red' : 'border-primary-100 hover:border-primary-300'"
            >
              <img
                :src="getThumbnailUrl(img)"
                :alt="`${product.name} ${idx + 1}`"
                class="w-full h-full object-cover"
                loading="lazy"
              >
            </div>
          </div>
        </div>

        <!-- Product Info -->
        <div>
          <p class="text-primary-600 text-xs uppercase tracking-wider mb-2">{{ product.category ? product.category.name : 'Aksesori' }}</p>
          <h1 class="font-display text-3xl md:text-4xl font-bold text-accent-dark mb-4">{{ product.name }}</h1>
          <div class="flex items-center gap-3 mb-6">
            <p class="text-primary-600 text-3xl font-bold">
              Rp {{ (product.promo_price || product.price).toLocaleString() }}
            </p>
            <p v-if="product.promo_price" class="text-accent-gray text-xl line-through">
              Rp {{ product.price.toLocaleString() }}
            </p>
          </div>

          <!-- Varian Produk -->
          <div v-if="product.variants && product.variants.length > 0" class="mb-8">
            <h2 class="font-display text-xl font-bold text-accent-dark mb-6">Varian Produk</h2>
            <div v-for="variant in product.variants" :key="variant.type" class="mb-6">
              <h3 class="text-sm font-semibold text-accent-dark mb-4">
                {{ 
                  variant.type === 'warna' ? 'Warna' : 
                  variant.type === 'teks' ? 'Teks' : 
                  variant.type === 'ukuran' ? 'Ukuran' : variant.type 
                }}
              </h3>
              <div class="flex flex-wrap gap-3">
                <button
                  v-for="(option, idx) in variant.options"
                  :key="idx"
                  @click="setSelectedVariant(variant.type, idx)"
                  class="px-4 py-2 border-2 rounded-lg text-sm font-medium transition-all"
                  :class="
                    selectedVariants[variant.type] === idx 
                      ? 'border-primary-600 bg-primary-50 text-primary-700 ring-4 ring-primary-100' 
                      : 'border-gray-200 text-accent-gray hover:border-primary-300 hover:text-accent-dark'
                  "
                >
                  {{ option }}
                </button>
              </div>
            </div>
          </div>

          <!-- Product Description -->
          <div v-if="product.description" class="mb-6">
            <h3 class="font-display text-sm font-bold text-accent-dark mb-3">Deskripsi</h3>
            <p class="text-accent-gray leading-relaxed text-sm">{{ product.description }}</p>
          </div>

          <!-- Stock Info -->
          <div class="mb-8">
            <p class="text-sm" :class="product.stock < 10 ? 'text-primary-600' : 'text-accent-gray'">
              Stok: <span class="font-bold">{{ product.stock }}</span>
              <span v-if="product.stock < 10" class="ml-2 font-medium">Segera habis!</span>
            </p>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 mb-12">
            <button
              @click="showBuyModal = true"
              class="flex-1 flex items-center justify-center gap-2 px-8 py-4 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-bold hover:from-primary-700 hover:to-primary-800 transition-all rounded-xl shadow-red hover:shadow-xl transform hover:-translate-y-0.5"
            >
              <span class="material-icons-round">shopping_cart</span>
              Buy Now
            </button>
            <router-link
              to="/home/products"
              class="flex-1 flex items-center justify-center gap-2 px-8 py-4 border-2 border-primary-200 text-accent-dark font-bold hover:bg-primary-50 transition-all rounded-xl"
            >
              <span class="material-icons-round">arrow_back</span>
              Kembali
            </router-link>
          </div>

          <!-- Specifications -->
          <div v-if="product.specifications && product.specifications.length > 0" class="border-t border-primary-100 pt-8">
            <h3 class="font-display text-xl font-bold text-accent-dark mb-6">Spesifikasi</h3>
            <div class="space-y-4">
              <div v-for="spec in product.specifications" :key="spec.key" class="flex justify-between py-3 border-b border-primary-50">
                <span class="text-accent-gray font-medium">{{ spec.key }}</span>
                <span class="text-accent-dark font-bold">{{ spec.value }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Buy Modal -->
    <div v-if="showBuyModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
      <div class="bg-white rounded-2xl shadow-xl max-w-md w-full overflow-hidden">
        <div class="p-6">
          <h3 class="font-display text-2xl font-bold text-accent-dark mb-6">Pilih Cara Pembelian</h3>
          
          <div class="space-y-4">
            <!-- WhatsApp -->
            <a
              :href="whatsAppLink"
              target="_blank"
              class="flex items-center gap-4 p-4 border-2 border-primary-600 rounded-xl hover:bg-primary-50 transition-all"
            >
              <div class="w-12 h-12 rounded-full flex items-center justify-center overflow-hidden">
                <img src="/asset/whatsapp.png" alt="WhatsApp" class="w-full h-full object-contain" />
              </div>
              <div class="flex-1">
                <h4 class="font-semibold text-accent-dark">WhatsApp</h4>
                <p class="text-sm text-accent-gray">+62 895-0179-8516</p>
              </div>
              <span class="material-icons-round text-primary-600">arrow_forward</span>
            </a>

            <!-- TikTok Shop -->
            <a
              :href="product?.tiktok_link || 'https://vt.tiktok.com/ZSQc1mvbx/?page=Mall'"
              target="_blank"
              class="flex items-center gap-4 p-4 border-2 border-primary-600 rounded-xl hover:bg-primary-50 transition-all"
            >
              <div class="w-12 h-12 rounded-full flex items-center justify-center overflow-hidden">
                <img src="/asset/tiktok.png" alt="TikTok Shop" class="w-full h-full object-contain" />
              </div>
              <div class="flex-1">
                <h4 class="font-semibold text-accent-dark">TikTok Shop</h4>
                <p class="text-sm text-accent-gray">Beli di TikTok Shop</p>
              </div>
              <span class="material-icons-round text-primary-600">arrow_forward</span>
            </a>

            <!-- Shopee -->
            <a
              :href="product?.shopee_link || 'https://shopee.co.id/'"
              target="_blank"
              class="flex items-center gap-4 p-4 border-2 border-primary-600 rounded-xl hover:bg-primary-50 transition-all"
            >
              <div class="w-12 h-12 rounded-full flex items-center justify-center overflow-hidden">
                <img src="/asset/shopee.png" alt="Shopee" class="w-full h-full object-contain" />
              </div>
              <div class="flex-1">
                <h4 class="font-semibold text-accent-dark">Shopee</h4>
                <p class="text-sm text-accent-gray">Beli di Shopee</p>
              </div>
              <span class="material-icons-round text-primary-600">arrow_forward</span>
            </a>
          </div>

          <button
            @click="showBuyModal = false"
            class="mt-6 w-full py-3 text-accent-gray font-medium hover:text-accent-dark transition-colors"
          >
            Tutup
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Not Found -->
  <div v-else-if="!loading" class="py-32 text-center">
    <span class="material-icons-round text-6xl mb-4 block text-gray-300">error_outline</span>
    <h2 class="font-display text-2xl font-bold text-accent-dark mb-4">Produk tidak ditemukan</h2>
    <router-link to="/home/products" class="inline-block px-6 py-3 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-bold hover:from-primary-700 hover:to-primary-800 transition-all rounded-xl shadow-red">
      Kembali ke Produk
    </router-link>
  </div>

  <!-- Loading -->
  <div v-else class="py-32 text-center">
    <span class="material-icons-round text-6xl mb-4 block text-primary-300 animate-pulse">hourglass_empty</span>
    <p class="text-accent-gray">Memuat...</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'

const route = useRoute()
const product = ref(null)
const loading = ref(true)
const currentImage = ref(null)
const categories = ref([])
const selectedVariants = ref({})
const showBuyModal = ref(false)

// Helper functions
function getThumbnailUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.thumbnail || galleryItem?.display || ''
}

function getDisplayUrl(galleryItem) {
  if (typeof galleryItem === 'string') return galleryItem
  return galleryItem?.display || galleryItem?.thumbnail || ''
}

const galleryImages = computed(() => {
  return product.value?.gallery || []
})

const whatsAppLink = computed(() => {
  let text = `Halo, saya tertarik dengan produk ${encodeURIComponent(product.value?.name || '')}`
  
  const variantParts = []
  if (product.value?.variants) {
    for (const variant of product.value.variants) {
      if (selectedVariants.value[variant.type] !== undefined && variant.options[selectedVariants.value[variant.type]]) {
        const variantName = 
          variant.type === 'warna' ? 'Warna' : 
          variant.type === 'teks' ? 'Teks' : 
          variant.type === 'ukuran' ? 'Ukuran' : variant.type
        variantParts.push(`${variantName}: ${variant.options[selectedVariants.value[variant.type]]}`)
      }
    }
  }
  
  if (variantParts.length > 0) {
    text += ` dengan ${variantParts.join(', ')}`
  }
  
  return `https://wa.me/6289501798516?text=${text}`
})

function setSelectedVariant(variantType, index) {
  selectedVariants.value[variantType] = index
}

onMounted(async () => {
  await loadCategories()
  await loadProduct()
})

async function loadCategories() {
  const { data } = await supabase
    .from('categories')
    .select('*')
    .order('name', { ascending: true })
  
  categories.value = data || []
}

async function loadProduct() {
  loading.value = true
  const { data } = await supabase
    .from('products')
    .select('*')
    .eq('slug', route.params.slug)
    .eq('status', 'published')
    .single()
  
  if (data) {
    product.value = {
      ...data,
      category: categories.value.find(c => c.id === data.category_id)
    }
    
    // Initialize selected variants
    if (data.variants) {
      for (const variant of data.variants) {
        if (variant.options.length > 0) {
          selectedVariants.value[variant.type] = 0
        }
      }
    }
  }
  
  if (data?.gallery?.[0]) {
    currentImage.value = getDisplayUrl(data.gallery[0])
  }
  loading.value = false
}
</script>
