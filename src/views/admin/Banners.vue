<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Banners</h3>
      <button @click="showModal = true" class="flex items-center gap-2 px-4 py-2.5 rounded-lg bg-red-600 text-white font-semibold hover:bg-red-700 transition-colors shadow-md">
        <span class="material-icons-round text-lg">add</span>
        Add
      </button>
    </div>

    <!-- Banners List -->
    <div class="space-y-4">
      <div 
        v-for="banner in banners" 
        :key="banner.id"
        class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden"
      >
        <div class="flex flex-col">
          <!-- Preview -->
          <div class="aspect-video bg-gray-100 relative">
            <div 
              v-if="banner.image_url" 
              class="absolute inset-0 bg-cover bg-center"
              :style="{ backgroundImage: `url(${banner.image_url})` }"
            ></div>
            <div v-else class="absolute inset-0 flex items-center justify-center">
              <span class="material-icons-round text-4xl text-gray-500">image</span>
            </div>
          </div>
          <!-- Info -->
          <div class="p-4 flex flex-col">
            <div class="flex items-start justify-between mb-3">
              <div>
                <h4 class="font-bold text-black">{{ banner.title || 'Untitled' }}</h4>
                <p class="text-gray-500 text-xs mt-0.5">{{ banner.description || '' }}</p>
              </div>
              <span class="px-2.5 py-1 text-xs font-bold rounded-full" :class="banner.is_active ? 'bg-green-100 text-green-800 border border-green-300' : 'bg-gray-100 text-gray-600 border border-gray-300'">
                {{ banner.is_active ? 'Active' : 'Inactive' }}
              </span>
            </div>
            
            <div class="space-y-2 text-xs flex-1">
              <div class="flex gap-2">
                <span class="text-gray-500 w-20">Link:</span>
                <a v-if="banner.link_url" :href="banner.link_url" target="_blank" class="text-black hover:text-red-600 hover:underline truncate flex-1">
                  {{ banner.link_url }}
                </a>
                <span v-else class="text-gray-400">-</span>
              </div>
              <div class="flex gap-2">
                <span class="text-gray-500 w-20">Order:</span>
                <span class="text-black">{{ banner.sort_order || 0 }}</span>
              </div>
            </div>

            <div class="flex gap-2.5 mt-3 pt-3 border-t border-gray-200">
              <button @click="editBanner(banner)" class="flex-1 px-3 py-2 rounded-lg border-2 border-black text-black text-xs font-semibold hover:bg-gray-50 transition-colors">
                Edit
              </button>
              <button @click="toggleActive(banner)" class="flex-1 px-3 py-2 rounded-lg text-white text-xs font-semibold transition-colors" :class="banner.is_active ? 'bg-orange-500 hover:bg-orange-600' : 'bg-green-500 hover:bg-green-600'">
                {{ banner.is_active ? 'Deactivate' : 'Activate' }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <div v-if="banners.length === 0" class="bg-white border-2 border-black rounded-lg p-8 text-center">
        <span class="material-icons-round text-4xl text-gray-400">campaign</span>
        <h4 class="font-semibold text-black mt-3">No banners yet</h4>
        <p class="text-gray-500 text-xs mt-1">Create your first banner</p>
      </div>
    </div>

    <!-- Add/Edit Banner Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-lg w-full my-4 rounded-xl border-2 border-black shadow-xl overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-black flex items-center gap-2">
            <span class="material-icons-round text-red-600">campaign</span>
            {{ editingBanner ? 'Edit' : 'Add Banner' }}
          </h3>
          <button @click="closeModal" class="text-gray-500 hover:text-black hover:bg-gray-100 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="saveBanner" class="p-4 space-y-4">
          <!-- Image Preview & Upload -->
          <div class="space-y-2">
            <label class="block text-xs font-semibold text-black">Banner Image</label>
            <div 
              class="aspect-video bg-gray-50 border-2 border-dashed border-gray-400 rounded-lg flex items-center justify-center overflow-hidden cursor-pointer hover:border-red-500 hover:bg-red-50 transition-all"
              @click="triggerFileInput"
            >
              <div v-if="form.image_url" class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: `url(${form.image_url})` }"></div>
              <div v-else class="text-center p-4">
                <span class="material-icons-round text-3xl text-gray-400 mb-1">upload_file</span>
                <p class="text-gray-500 text-xs">Click to upload or enter URL</p>
              </div>
            </div>
            <input type="file" ref="fileInputRef" accept="image/*" @change="handleFileUpload" class="hidden" />
            <div>
              <label class="block text-[10px] font-semibold text-gray-500 mb-1">Or enter image URL:</label>
              <input v-model="form.image_url" type="url" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500" placeholder="https://...">
            </div>
          </div>

          <!-- Basic Info -->
          <div class="space-y-3">
            <div>
              <label class="block text-xs font-semibold text-black mb-1">Title</label>
              <input v-model="form.title" type="text" required class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500" placeholder="Banner title...">
            </div>
            <div>
              <label class="block text-xs font-semibold text-black mb-1">Description</label>
              <textarea v-model="form.description" rows="2" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500" placeholder="Banner description..."></textarea>
            </div>
            <div>
              <label class="block text-xs font-semibold text-black mb-1">Link URL (optional)</label>
              <input v-model="form.link_url" type="url" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500" placeholder="https://...">
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div>
                <label class="block text-xs font-semibold text-black mb-1">Start Date (optional)</label>
                <input v-model="form.schedule_start" type="datetime-local" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500">
              </div>
              <div>
                <label class="block text-xs font-semibold text-black mb-1">End Date (optional)</label>
                <input v-model="form.schedule_end" type="datetime-local" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500">
              </div>
            </div>
            <div>
              <label class="block text-xs font-semibold text-black mb-1">Sort Order</label>
              <input v-model.number="form.sort_order" type="number" min="0" class="w-full px-3 py-2 rounded-lg border-2 border-black text-xs focus:outline-none focus:ring-2 focus:ring-red-500" placeholder="0">
            </div>
          </div>

          <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg border border-gray-200">
            <input v-model="form.is_active" type="checkbox" id="active" class="w-4 h-4 text-red-600 focus:ring-red-500 border-black rounded">
            <label for="active" class="text-xs font-semibold text-black cursor-pointer">Active immediately</label>
          </div>

          <div class="flex gap-2.5 pt-3 border-t-2 border-black">
            <button type="button" @click="closeModal" class="flex-1 px-4 py-2.5 rounded-lg border-2 border-black text-black font-semibold hover:bg-gray-50 transition-colors text-xs">Cancel</button>
            <button type="submit" class="flex-1 px-4 py-2.5 rounded-lg bg-red-600 text-white font-semibold hover:bg-red-700 transition-colors text-xs shadow-md">
              {{ editingBanner ? 'Update' : 'Add' }}
            </button>
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
const editingBanner = ref(null)
const fileInputRef = ref(null)
const form = ref({
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
  
  banners.value = data || []
}

function triggerFileInput() {
  fileInputRef.value?.click()
}

function handleFileUpload(event) {
  const file = event.target.files?.[0]
  if (file) {
    // Simple preview (in real app, you'd upload to storage)
    const reader = new FileReader()
    reader.onload = (e) => {
      form.value.image_url = e.target.result
    }
    reader.readAsDataURL(file)
  }
}

function editBanner(banner) {
  editingBanner.value = banner
  form.value = { ...banner }
  showModal.value = true
}

function toggleActive(banner) {
  banner.is_active = !banner.is_active
  // In real app, update in Supabase here
}

function saveBanner() {
  console.log('Saving banner:', form.value)
  if (editingBanner.value) {
    // Update existing banner
  } else {
    // Add new banner
    banners.value.push({
      id: Date.now(),
      ...form.value
    })
  }
  closeModal()
}

function closeModal() {
  showModal.value = false
  editingBanner.value = null
  form.value = {
    title: '',
    description: '',
    image_url: '',
    link_url: '',
    schedule_start: '',
    schedule_end: '',
    sort_order: 0,
    is_active: true
  }
}
</script>
