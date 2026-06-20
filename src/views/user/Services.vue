<template>
  <div class="py-12 bg-gray-100 min-h-screen">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-12">
        <div class="inline-block px-4 py-1 bg-red-100 text-red-700 rounded-full text-sm font-bold mb-4">
          Layanan Kami
        </div>
        <h1 class="font-display text-4xl md:text-5xl font-bold text-black">Apa Yang Kami Tawarkan?</h1>
        <p class="text-gray-600 mt-4 max-w-2xl mx-auto text-lg">
          Berbagai layanan kreatif untuk kebutuhan visual brand Anda.
        </p>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div
          v-for="service in services"
          :key="service.id"
          class="bg-white border-2 border-black rounded-xl p-8 hover:shadow-lg transition-all"
        >
          <div class="w-16 h-16 bg-red-100 rounded-lg flex items-center justify-center mb-6">
            <span class="material-icons-round text-red-600 text-4xl">{{ service.icon }}</span>
          </div>
          <h2 class="font-display text-2xl font-bold text-black mb-4">{{ service.title }}</h2>
          <p class="text-gray-600 mb-6">{{ service.description }}</p>
          <ul class="space-y-2 mb-6">
            <li v-for="item in service.features" :key="item" class="flex items-center gap-2 text-sm text-gray-700">
              <span class="material-icons-round text-green-500 text-lg">check_circle</span>
              {{ item }}
            </li>
          </ul>
          <router-link to="/contact" class="inline-block px-6 py-2.5 bg-red-600 text-white font-bold rounded-lg hover:bg-red-700 transition-colors">
            Konsultasi Sekarang
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const services = ref([
  {
    id: 1,
    title: 'Photography',
    icon: 'camera_alt',
    description: 'Jasa fotografi profesional untuk berbagai kebutuhan dengan hasil berkualitas tinggi.',
    features: ['Product Photography', 'Portrait Photography', 'Event Coverage', 'Food Photography']
  },
  {
    id: 2,
    title: 'Videography',
    icon: 'videocam',
    description: 'Pembuatan video cinematic untuk promosi brand, iklan, dan dokumentasi acara.',
    features: ['Commercial Video', 'Wedding Videography', 'Event Documentation', 'Corporate Video']
  },
  {
    id: 3,
    title: 'Video Editing',
    icon: 'edit',
    description: 'Jasa editing video profesional dengan grading warna dan efek yang menarik.',
    features: ['Color Grading', 'Motion Graphics', 'Video Transitions', 'Sound Design']
  },
  {
    id: 4,
    title: 'Social Media Content',
    icon: 'phone_iphone',
    description: 'Pembuatan konten khusus untuk Instagram, TikTok, dan platform sosial lainnya.',
    features: ['Instagram Reels', 'TikTok Content', 'Story Design', 'Feed Layout']
  },
  {
    id: 5,
    title: 'Design & Branding',
    icon: 'palette',
    description: 'Desain grafis dan pengembangan identitas brand yang konsisten dan berkesan.',
    features: ['Logo Design', 'Brand Identity', 'Packaging Design', 'Social Media Design']
  }
])
</script>
