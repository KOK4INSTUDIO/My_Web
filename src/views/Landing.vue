<template>
  <div>
    <!-- Hero Section (Full Screen) -->
    <section class="relative bg-white overflow-hidden h-screen hero-section">
      <div v-if="currentSlide === 0" class="absolute inset-0">
        <video
          ref="videoRef"
          src="/asset/6DTK.mp4"
          autoplay
          muted
          playsinline
          class="w-full h-full object-cover"
          @ended="onVideoEnded"
        />
      </div>
      <div v-else class="absolute inset-0">
        <img
          src="/asset/Page01.png"
          alt="Carousel Image"
          class="w-full h-full object-cover"
        />
      </div>
      
      <!-- Overlay -->
      <div class="absolute inset-0 bg-black/40"></div>
      
      <!-- Hero Content -->
      <div class="absolute inset-0 flex flex-col items-center justify-center text-center px-4 z-10">
        <img src="/asset/logo.png" alt="KOK4INSTUDIO" class="h-20 md:h-28 object-contain mb-5 invert" />
        <h1 class="font-display text-2xl md:text-4xl font-bold text-white mb-3">Mari Berkolaborasi</h1>
        <p class="text-white/80 text-sm md:text-base max-w-xl mb-7">
          Layanan custom fashion dengan sentuhan pribadi
        </p>
        <div class="flex flex-col sm:flex-row gap-3">
          <router-link to="/user/login" class="px-7 py-3 bg-white text-primary-700 font-bold hover:bg-gray-100 transition-all rounded-lg">
            Masuk
          </router-link>
          <router-link to="/user/register" class="px-7 py-3 border-2 border-white text-white font-bold hover:bg-white/10 transition-all rounded-lg">
            Daftar
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onBeforeUnmount } from 'vue'

const currentSlide = ref(0)
const videoRef = ref(null)
let imageTimer = null

function onVideoEnded() {
  currentSlide.value = 1
  imageTimer = setTimeout(() => {
    currentSlide.value = 0
    if (videoRef.value) {
      videoRef.value.currentTime = 0
      videoRef.value.play()
    }
  }, 30000)
}

onBeforeUnmount(() => {
  if (imageTimer) {
    clearTimeout(imageTimer)
  }
})
</script>

<style scoped>
/* Memastikan video dan gambar responsif di hero section saja */
.hero-section video,
.hero-section img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}
</style>