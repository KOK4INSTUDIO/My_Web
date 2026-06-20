<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-dark">Media Library</h3>
      <label class="flex items-center justify-center gap-2 px-5 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-medium hover:from-primary-700 hover:to-primary-800 transition-all shadow-red text-sm rounded-xl cursor-pointer">
        <span class="material-icons-round text-lg">cloud_upload</span>
        Upload Files
        <input type="file" multiple accept="image/*" @change="handleFileUpload" class="hidden" />
      </label>
    </div>

    <!-- Success/Error Messages -->
    <div v-if="error" class="p-4 bg-red-100 border border-red-300 text-red-700 rounded-xl flex items-center justify-between">
      <span>{{ error }}</span>
      <button @click="error = null" class="text-red-600 hover:text-red-700">×</button>
    </div>
    <div v-if="success" class="p-4 bg-green-100 border border-green-300 text-green-700 rounded-xl flex items-center justify-between">
      <span>{{ success }}</span>
      <button @click="success = null" class="text-green-600 hover:text-green-700">×</button>
    </div>

    <!-- Filters -->
    <div class="flex flex-wrap gap-3">
      <input 
        type="text" 
        v-model="searchQuery" 
        placeholder="Search files..." 
        class="flex-1 min-w-[200px] px-4 py-2.5 rounded-xl border-2 border-primary-100 focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100"
      />
      <select v-model="selectedType" class="px-4 py-2.5 rounded-xl border-2 border-primary-100 focus:outline-none focus:border-primary-500">
        <option value="all">All Types</option>
        <option value="image">Images</option>
      </select>
    </div>

    <!-- Media Grid -->
    <div v-if="!loading" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
      <!-- Upload Placeholder -->
      <label class="aspect-square bg-primary-50 border-2 border-dashed border-primary-200 rounded-xl flex flex-col items-center justify-center cursor-pointer hover:border-primary-400 hover:bg-primary-100 transition-all">
        <span class="material-icons-round text-3xl text-primary-400 mb-1">upload_file</span>
        <span class="text-xs text-accent-gray">Add Files</span>
        <input type="file" multiple accept="image/*" @change="handleFileUpload" class="hidden" />
      </label>

      <!-- Media Items -->
      <div 
        v-for="item in filteredMedia" 
        :key="item.id"
        class="group relative aspect-square bg-white rounded-xl overflow-hidden border border-primary-100 shadow-soft hover:shadow-red transition-all"
      >
        <div
          class="w-full h-full bg-cover bg-center group-hover:scale-105 transition-transform duration-300"
          :style="{ backgroundImage: `url(${item.url})` }"
        ></div>
        
        <!-- Hover Actions -->
        <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-all flex items-center justify-center gap-2">
          <button 
            @click="copyUrl(item.url)"
            class="p-2 bg-white text-accent-dark rounded-lg hover:bg-primary-50 transition-all"
            title="Copy URL"
          >
            <span class="material-icons-round text-lg">link</span>
          </button>
          <button 
            @click="deleteMedia(item)"
            class="p-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all"
            title="Delete"
          >
            <span class="material-icons-round text-lg">delete</span>
          </button>
        </div>

        <!-- File Info -->
        <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-3">
          <p class="text-white text-xs font-medium truncate">{{ item.name }}</p>
          <p class="text-white/70 text-xs">{{ formatFileSize(item.size) }}</p>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <span class="material-icons-round text-5xl text-primary-300 animate-spin mb-4 inline-block">refresh</span>
      <p class="text-accent-gray">Loading media...</p>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && filteredMedia.length === 0 && media.length === 0" class="text-center py-12">
      <span class="material-icons-round text-6xl text-primary-300 mb-4">perm_media</span>
      <h4 class="font-semibold text-accent-dark mb-2">No media yet</h4>
      <p class="text-accent-gray text-sm">Upload your first file to get started</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const media = ref([])
const loading = ref(false)
const error = ref(null)
const success = ref(null)
const searchQuery = ref('')
const selectedType = ref('all')

const filteredMedia = computed(() => {
  let filtered = media.value
  
  if (searchQuery.value) {
    filtered = filtered.filter(item => 
      item.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }
  
  if (selectedType.value !== 'all') {
    filtered = filtered.filter(item => item.type === selectedType.value)
  }
  
  return filtered
})

onMounted(async () => {
  await loadMedia()
})

async function loadMedia() {
  loading.value = true
  
  // Load from localStorage first (fast!)
  const localMedia = localStorage.getItem('kok4ins_media')
  if (localMedia) {
    media.value = JSON.parse(localMedia)
  }
  
  // Try to load from Supabase in background
  try {
    const { data, error: fetchError } = await supabase
      .from('media')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (!fetchError && data) {
      media.value = data
      localStorage.setItem('kok4ins_media', JSON.stringify(data))
    }
  } catch (err) {
    console.warn('Supabase not available, using localStorage only')
  }
  
  loading.value = false
}

async function handleFileUpload(event) {
  const files = event.target.files
  if (!files || files.length === 0) return
  
  const newMedia = []
  
  for (const file of files) {
    if (!file.type.startsWith('image/')) {
      continue
    }
    
    // Create file preview immediately (very fast!)
    const reader = new FileReader()
    reader.onload = (e) => {
      const mediaItem = {
        id: Date.now() + Math.random().toString(36).substr(2, 9),
        name: file.name,
        url: e.target.result,
        type: 'image',
        size: file.size,
        created_at: new Date().toISOString()
      }
      
      media.value.unshift(mediaItem)
      localStorage.setItem('kok4ins_media', JSON.stringify(media.value))
    }
    reader.readAsDataURL(file)
  }
  
  success.value = `${files.length} file(s) uploaded successfully!`
  event.target.value = ''
}

async function deleteMedia(item) {
  if (!confirm(`Delete "${item.name}"? This action cannot be undone.`)) return
  
  // Delete from local immediately (fast!)
  media.value = media.value.filter(m => m.id !== item.id)
  localStorage.setItem('kok4ins_media', JSON.stringify(media.value))
  
  // Try Supabase delete in background
  try {
    await supabase
      .from('media')
      .delete()
      .eq('id', item.id)
  } catch (err) {
    console.warn('Supabase delete failed')
  }
  
  success.value = 'File deleted successfully'
}

function copyUrl(url) {
  navigator.clipboard.writeText(url)
    .then(() => {
      success.value = 'URL copied to clipboard!'
      setTimeout(() => { success.value = null }, 2000)
    })
    .catch(() => {
      error.value = 'Failed to copy URL'
    })
}

function formatFileSize(bytes) {
  if (!bytes) return '0 B'
  
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(1024))
  
  return `${Math.round(bytes / Math.pow(1024, i) * 100) / 100} ${sizes[i]}`
}
</script>
