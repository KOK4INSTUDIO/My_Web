<template>
  <div class="space-y-5">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-3">
      <h3 class="font-display text-lg font-bold text-black">Categories</h3>
      <button @click="showModal = true" class="flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg bg-red-600 text-white font-semibold hover:bg-red-700 transition-colors shadow-md text-sm">
        <span class="material-icons-round text-lg">add</span>
        Add
      </button>
    </div>

    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="divide-y divide-gray-200">
        <div v-for="category in categories" :key="category.id" class="p-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-gray-100 border border-gray-300 rounded flex items-center justify-center">
                <span class="material-icons-round text-gray-600">folder</span>
              </div>
              <div class="min-w-0 flex-1">
                <p class="font-semibold text-black text-sm">{{ category.name }}</p>
                <p class="text-xs text-gray-500">{{ category.slug }}</p>
                <p v-if="category.parent" class="text-xs text-gray-500 mt-1 flex items-center gap-1">
                  <span class="material-icons-round text-xs">subdirectory_arrow_right</span>
                  Parent: {{ category.parent.name }}
                </p>
              </div>
            </div>
            <div class="flex items-center gap-1.5">
              <button class="text-gray-500 hover:text-black p-1.5 rounded transition-colors">
                <span class="material-icons-round text-base">edit</span>
              </button>
              <button class="text-red-600 hover:text-red-700 p-1.5 rounded transition-colors">
                <span class="material-icons-round text-base">delete</span>
              </button>
            </div>
          </div>
          
          <!-- Sub-categories -->
          <div v-if="category.children?.length > 0" class="ml-10 md:ml-14 mt-4 space-y-2">
            <div v-for="child in category.children" :key="child.id" class="flex items-center justify-between border-l-2 border-gray-300 pl-4 py-2">
              <div class="min-w-0 flex-1">
                <p class="text-black text-sm">{{ child.name }}</p>
                <p class="text-xs text-gray-500">{{ child.slug }}</p>
              </div>
              <div class="flex items-center gap-1">
                <button class="text-gray-500 hover:text-black p-1 rounded transition-colors">
                  <span class="material-icons-round text-lg">edit</span>
                </button>
                <button class="text-red-600 hover:text-red-700 p-1 rounded transition-colors">
                  <span class="material-icons-round text-lg">delete</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        <div v-if="categories.length === 0" class="p-8 text-center">
          <span class="material-icons-round text-4xl mb-2 block text-gray-300">folder_off</span>
          <p class="text-gray-500 text-sm">No categories yet. Add your first category!</p>
        </div>
      </div>
    </div>

    <!-- Modal Add Category -->
    <div v-if="showModal" class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div class="bg-white max-w-md w-full rounded-xl border-2 border-black shadow-xl overflow-hidden">
        <div class="p-4 border-b-2 border-black flex items-center justify-between">
          <h3 class="font-bold text-black flex items-center gap-2">
            <span class="material-icons-round text-red-600">create_new_folder</span>
            Add Category
          </h3>
          <button @click="showModal = false" class="text-gray-500 hover:text-black hover:bg-gray-100 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="addCategory" class="p-4 space-y-4">
          <div>
            <label class="block text-xs font-bold text-black mb-1">Name</label>
            <input v-model="newCategory.name" type="text" required class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Parent Category (optional)</label>
            <select v-model="newCategory.parent_id" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs">
              <option value="">None (Main Category)</option>
              <option v-for="cat in parentCategories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Description</label>
            <textarea v-model="newCategory.description" rows="3" class="w-full px-3 py-2 rounded-lg border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 text-xs"></textarea>
          </div>
          <div class="flex gap-2.5 pt-2">
            <button type="button" @click="showModal = false" class="flex-1 px-4 py-2.5 rounded-lg border-2 border-black text-black font-bold hover:bg-gray-50 transition-colors text-xs">Cancel</button>
            <button type="submit" class="flex-1 px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">Add Category</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const categories = ref([])
const showModal = ref(false)
const newCategory = ref({
  name: '',
  slug: '',
  description: '',
  parent_id: null
})

const parentCategories = computed(() => categories.value.filter(c => !c.parent_id))

onMounted(async () => {
  await loadCategories()
})

async function loadCategories() {
  const { data } = await supabase
    .from('categories')
    .select('*, parent:categories!categories_parent_id_fkey(*)')
    .order('name')
  
  // Build hierarchy
  const parentCats = (data || []).filter(c => !c.parent_id)
  const childCats = (data || []).filter(c => c.parent_id)
  
  categories.value = parentCats.map(parent => ({
    ...parent,
    children: childCats.filter(child => child.parent_id === parent.id)
  }))
}

function addCategory() {
  console.log('Adding category:', newCategory.value)
  showModal.value = false
  newCategory.value = { name: '', slug: '', description: '', parent_id: null }
}
</script>