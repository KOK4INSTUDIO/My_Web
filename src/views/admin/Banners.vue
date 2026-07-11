<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-semibold text-brand-black">Banners</h3>
      <button @click="showModal = true" class="btn-primary">+ Add Banner</button>
    </div>

    <!-- Banners List -->
    <div class="grid grid-cols-1 gap-6">
      <div 
        v-for="banner in banners" 
        :key="banner.id"
        class="bg-brand-white border border-brand-border"
      >
        <div class="flex flex-col lg:flex-row">
          <!-- Preview -->
          <div class="lg:w-1/2 aspect-video bg-brand-surface relative">
            <div 
              v-if="banner.image_url" 
              class="absolute inset-0 bg-cover bg-center"
              :style="{ backgroundImage: `url(${banner.image_url})` }"
            ></div>
            <div v-else class="absolute inset-0 flex items-center justify-center">
              <span class="text-6xl">🖼️</span>
            </div>
          </div>
          <!-- Info -->
          <div class="lg:w-1/2 p-6 flex flex-col">
            <div class="flex items-start justify-between mb-4">
              <div>
                <h4 class="font-semibold text-brand-black text-lg">{{ banner.title || 'Untitled Banner' }}</h4>
                <p class="text-brand-medium text-sm">{{ banner.description || 'No description' }}</p>
              </div>
              <span class="px-3 py-1 text-xs font-medium" :class="banner.is_active ? 'bg-green-100 text-green-800' : 'bg-brand-surface text-brand-dark'">
                {{ banner.is_active ? 'Active' : 'Inactive' }}
              </span>
            </div>
            
            <div class="space-y-3 text-sm flex-1">
              <div class="flex gap-2">
                <span class="text-brand-medium w-24">Link:</span>
                <a v-if="banner.link_url" :href="banner.link_url" target="_blank" class="text-brand-black hover:underline truncate flex-1">
                  {{ banner.link_url }}
                </a>
                <span v-else class="text-brand-medium">-</span>
              </div>
              <div class="flex gap-2">
                <span class="text-brand-medium w-24">Schedule:</span>
                <span class="text-brand-black">
                  {{ banner.schedule_start ? new Date(banner.schedule_start).toLocaleDateString('id-ID') : 'Immediately' }}
                  {{ banner.schedule_end ? ` - ${new Date(banner.schedule_end).toLocaleDateString('id-ID')}` : '' }}
                </span>
              </div>
              <div class="flex gap-2">
                <span class="text-brand-medium w-24">Order:</span>
                <span class="text-brand-black">{{ banner.sort_order || 0 }}</span>
              </div>
            </div>

            <div class="flex gap-2 mt-4 pt-4 border-t border-brand-border">
              <button class="flex-1 btn-secondary text-sm py-2">Edit</button>
              <button class="flex-1 btn-primary text-sm py-2">
                {{ banner.is_active ? 'Deactivate' : 'Activate' }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <div v-if="banners.length === 0" class="bg-brand-white border border-brand-border p-12 text-center">
        <span class="text-6xl">🎯</span>
        <h4 class="font-medium text-brand-black mt-4">No banners yet</h4>
        <p class="text-brand-medium mt-2">Create your first banner</p>
      </div>
    </div>

    <!-- Add Banner Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-brand-white max-w-2xl w-full my-8">
        <div class="p-6 border-b border-brand-border flex items-center justify-between">
          <h3 class="font-semibold text-brand-black">Add Banner</h3>
          <button @click="showModal = false" class="text-brand-medium hover:text-brand-black">✕</button>
        </div>
        <form @submit.prevent="addBanner" class="p-6 space-y-4">
          <div>
            <label class="block text-sm font-medium text-brand-black mb-2">Title</label>
            <input v-model="newBanner.title" type="text" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
          </div>
          <div>
            <label class="block text-sm font-medium text-brand-black mb-2">Description</label>
            <textarea v-model="newBanner.description" rows="2" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black"></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-brand-black mb-2">Image URL</label>
            <input v-model="newBanner.image_url" type="url" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
          </div>
          <div>
            <label class="block text-sm font-medium text-brand-black mb-2">Link URL (optional)</label>
            <input v-model="newBanner.link_url" type="url" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-brand-black mb-2">Start Date (optional)</label>
              <input v-model="newBanner.schedule_start" type="datetime-local" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
            </div>
            <div>
              <label class="block text-sm font-medium text-brand-black mb-2">End Date (optional)</label>
              <input v-model="newBanner.schedule_end" type="datetime-local" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-brand-black mb-2">Sort Order</label>
            <input v-model.number="newBanner.sort_order" type="number" min="0" class="w-full px-4 py-3 border border-brand-border focus:outline-none focus:border-brand-black">
          </div>
          <div class="flex items-center gap-2">
            <input v-model="newBanner.is_active" type="checkbox" id="active" class="w-4 h-4">
            <label for="active" class="text-sm text-brand-black">Active immediately</label>
          </div>
          <div class="flex gap-3 pt-2">
            <button type="button" @click="showModal = false" class="flex-1 btn-secondary">Cancel</button>
            <button type="submit" class="flex-1 btn-primary">Add Banner</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const banners = ref([])
const showModal = ref(false)
const newBanner = ref({
  title: '',
  description: '',
  image_url: '',
  link_url: '',
  schedule_start: '',
  schedule_end: '',
  sort_order: 0,
  is_active: true
})

onMounted(async () => {
  await loadBanners()
})

async function loadBanners() {
  const { data } = await supabase
    .from('banners')
    .select('*')
    .order('sort_order', { ascending: true })
  
  // Replace old brand name in banners
  const updatedBanners = (data || []).map(banner => ({
    ...banner,
    title: banner.title?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™'),
    description: banner.description?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™')
  }))
  
  banners.value = updatedBanners
}

function addBanner() {
  console.log('Adding banner:', newBanner.value)
  showModal.value = false
  newBanner.value = { title: '', description: '', image_url: '', link_url: '', schedule_start: '', schedule_end: '', sort_order: 0, is_active: true }
}
</script>
