<template>
  <div class="space-y-5">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-lg font-bold text-black">Media Library</h3>
      <label class="px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-sm cursor-pointer">
        <input type="file" multiple accept="image/*" @change="handleUpload" class="hidden">
        + Upload Files
      </label>
    </div>

    <!-- Filter & Search -->
    <div class="flex gap-2 flex-wrap">
      <input 
        v-model="searchQuery"
        type="text" 
        placeholder="Search files..."
        class="flex-1 min-w-48 px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm bg-white"
      >
      <select class="px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-sm bg-white">
        <option value="">All Types</option>
        <option value="image">Images</option>
        <option value="document">Documents</option>
      </select>
    </div>

    <!-- Grid Media -->
    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
      <div 
        v-for="media in filteredMedia" 
        :key="media.id"
        class="group relative bg-white border-2 border-black rounded-lg overflow-hidden cursor-pointer"
      >
        <div class="aspect-square bg-gray-100 flex items-center justify-center overflow-hidden">
          <div v-if="media.type === 'image'" class="w-full h-full bg-cover bg-center" :style="{ backgroundImage: `url(${media.url})` }"></div>
          <div v-else class="text-3xl">📄</div>
        </div>
        <div class="p-2">
          <p class="text-black text-xs truncate">{{ media.name }}</p>
          <p class="text-gray-500 text-[10px]">{{ formatSize(media.size) }}</p>
        </div>
        <div class="absolute inset-0 bg-black/80 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-1.5">
          <button @click="copyUrl(media.url)" class="bg-white text-black px-2 py-1 text-xs font-bold hover:bg-gray-100 rounded">
            Copy URL
          </button>
          <button class="bg-red-600 text-white px-2 py-1 text-xs font-bold hover:bg-red-700 rounded">
            Delete
          </button>
        </div>
      </div>

      <!-- Upload placeholder -->
      <label class="aspect-square border-2 border-dashed border-gray-400 rounded-lg flex items-center justify-center cursor-pointer hover:border-red-600 hover:bg-red-50 transition-colors">
        <div class="text-center">
          <span class="text-3xl">+</span>
          <p class="text-gray-500 text-xs mt-1">Add Files</p>
        </div>
        <input type="file" multiple accept="image/*" @change="handleUpload" class="hidden">
      </label>
    </div>

    <!-- Empty state -->
    <div v-if="mediaFiles.length === 0" class="bg-white border-2 border-black rounded-lg p-8 text-center">
      <span class="text-4xl">🖼️</span>
      <h4 class="font-semibold text-black mt-3">No files yet</h4>
      <p class="text-gray-500 text-xs mt-1">Upload your first file to get started</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const mediaFiles = ref([
  { id: 1, name: 'product-1.jpg', url: 'https://via.placeholder.com/400', type: 'image', size: 102400, created_at: new Date() },
  { id: 2, name: 'banner-summer.jpg', url: 'https://via.placeholder.com/800x400', type: 'image', size: 204800, created_at: new Date() },
  { id: 3, name: 'logo-brand.png', url: 'https://via.placeholder.com/200', type: 'image', size: 51200, created_at: new Date() }
])

const searchQuery = ref('')

const filteredMedia = computed(() => {
  if (!searchQuery.value) return mediaFiles.value
  return mediaFiles.value.filter(m => 
    m.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

function handleUpload(event) {
  const files = event.target.files
  console.log('Uploading files:', files)
}

function copyUrl(url) {
  navigator.clipboard.writeText(url)
  alert('URL copied to clipboard!')
}

function formatSize(bytes) {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}
</script>
