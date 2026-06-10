<template>
  <div class="space-y-5">
    <h3 class="font-display text-lg font-bold text-black">Settings</h3>

    <!-- General Settings -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2">
          🏪 General
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">Brand Name</label>
          <input v-model="settings.brand_name" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Tagline</label>
          <input v-model="settings.tagline" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Logo URL</label>
          <input v-model="settings.logo_url" type="url" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Favicon URL</label>
          <input v-model="settings.favicon_url" type="url" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        </div>
      </div>
    </div>

    <!-- SEO Settings -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2">
          🔍 SEO
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">Meta Title</label>
          <input v-model="settings.meta_title" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
          <p class="text-gray-500 text-[10px] mt-1">{{ settings.meta_title?.length || 0 }}/60 characters</p>
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Meta Description</label>
          <textarea v-model="settings.meta_description" rows="3" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm"></textarea>
          <p class="text-gray-500 text-[10px] mt-1">{{ settings.meta_description?.length || 0 }}/160 characters</p>
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Meta Keywords</label>
          <input v-model="settings.meta_keywords" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm" placeholder="comma separated">
        </div>
      </div>
    </div>

    <!-- Footer Settings -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2">
          📄 Footer
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">Footer Text</label>
          <textarea v-model="settings.footer_text" rows="2" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm"></textarea>
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Copyright</label>
          <input v-model="settings.copyright" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm" placeholder="© 2024 KOK4INSTUDIO">
        </div>
      </div>
    </div>

    <!-- Analytics -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2">
          📊 Analytics
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">Google Analytics ID</label>
          <input v-model="settings.ga_id" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm" placeholder="G-XXXXXXXXXX">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Facebook Pixel ID</label>
          <input v-model="settings.fb_pixel" type="text" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm">
        </div>
      </div>
    </div>

    <div class="flex justify-end">
      <button @click="saveSettings" class="px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-sm">Save All Changes</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const settings = ref({
  brand_name: 'KOK4INSTUDIO',
  tagline: 'Premium Fashion & Accessories',
  logo_url: '',
  favicon_url: '',
  meta_title: 'KOK4INSTUDIO - Premium Fashion & Accessories',
  meta_description: 'Discover premium fashion and accessories at KOK4INSTUDIO. High quality products with timeless design.',
  meta_keywords: 'fashion, accessories, premium, clothing',
  footer_text: '',
  copyright: '© 2024 KOK4INSTUDIO. All rights reserved.',
  ga_id: '',
  fb_pixel: ''
})

function saveSettings() {
  console.log('Saving settings:', settings.value)
  alert('Settings saved successfully!')
}
</script>
