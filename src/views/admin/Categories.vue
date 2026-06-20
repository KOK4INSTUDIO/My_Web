<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-black">Categories</h3>
      <button @click="showModal = true" class="flex items-center justify-center gap-2 px-5 py-2.5 bg-accent-black text-white font-medium hover:bg-accent-dark transition-colors text-sm">
        <span class="material-icons-round text-lg">add</span>
        Add Category
      </button>
    </div>

    <!-- Categories List -->
    <div class="bg-white border border-gray-200 rounded-lg overflow-hidden">
      <div class="divide-y divide-gray-100">
        <div v-for="category in categories" :key="category.id" class="p-5">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-gray-100 border border-gray-200 rounded flex items-center justify-center">
                <span class="material-icons-round text-gray-500">folder</span>
              </div>
              <div class="min-w-0 flex-1">
                <router-link 
                  :to="`/admin/products/category/${category.id}`" 
                  class="font-medium text-accent-black text-sm hover:text-primary-600 transition-colors"
                >
                  {{ category.name }}
                </router-link>
                <p class="text-xs text-gray-500">{{ category.slug }}</p>
                <p v-if="category.parent" class="text-xs text-gray-500 mt-1 flex items-center gap-1">
                  <span class="material-icons-round text-xs">subdirectory_arrow_right</span>
                  Parent: {{ category.parent.name }}
                </p>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <button @click="editCategory(category)" class="text-gray-500 hover:text-accent-black p-1.5 rounded transition-colors">
                <span class="material-icons-round text-lg">edit</span>
              </button>
              <button @click="deleteCategory(category.id)" class="text-red-600 hover:text-red-700 p-1.5 rounded transition-colors">
                <span class="material-icons-round text-lg">delete</span>
              </button>
            </div>
          </div>
          
          <!-- Sub-categories -->
          <div v-if="category.children?.length > 0" class="ml-10 md:ml-14 mt-4 space-y-2">
            <div v-for="child in category.children" :key="child.id" class="flex items-center justify-between border-l border-gray-200 pl-4 py-2">
              <div class="min-w-0 flex-1">
                <router-link 
                  :to="`/admin/products/category/${child.id}`" 
                  class="text-accent-black text-sm hover:text-primary-600 transition-colors"
                >
                  {{ child.name }}
                </router-link>
                <p class="text-xs text-gray-500">{{ child.slug }}</p>
              </div>
              <div class="flex items-center gap-2">
                <button @click="editCategory(child)" class="text-gray-500 hover:text-accent-black p-1 rounded transition-colors">
                  <span class="material-icons-round text-lg">edit</span>
                </button>
                <button @click="deleteCategory(child.id)" class="text-red-600 hover:text-red-700 p-1 rounded transition-colors">
                  <span class="material-icons-round text-lg">delete</span>
                </button>
              </div>
            </div>
          </div>
        </div>
        <div v-if="categories.length === 0" class="p-10 text-center">
          <span class="material-icons-round text-5xl mb-3 block text-gray-300">folder_off</span>
          <p class="text-gray-500 text-sm">No categories yet. Add your first category!</p>
        </div>
      </div>
    </div>

    <!-- Modal Add/Edit Category -->
    <div v-if="showModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div class="bg-white max-w-md w-full my-4 rounded-xl border border-gray-200 shadow-lg overflow-hidden">
        <div class="p-5 border-b border-gray-200 flex items-center justify-between sticky top-0 bg-white z-10">
          <h3 class="font-bold text-accent-black flex items-center gap-2">
            <span class="material-icons-round text-accent-black">create_new_folder</span>
            {{ editingId ? 'Edit Category' : 'Add Category' }}
          </h3>
          <button @click="showModal = false" class="text-gray-400 hover:text-accent-black hover:bg-gray-50 p-1.5 rounded-full transition-colors">
            <span class="material-icons-round">close</span>
          </button>
        </div>
        <form @submit.prevent="saveCategory" class="p-5 space-y-4">
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Name</label>
            <input v-model="form.name" type="text" required @input="generateSlug" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm">
          </div>
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Parent Category (optional)</label>
            <select v-model="form.parent_id" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm bg-white">
              <option value="">None (Main Category)</option>
              <option v-for="cat in parentCategories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-gray-700 mb-1.5">Description</label>
            <textarea v-model="form.description" rows="3" class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm"></textarea>
          </div>
          <div class="flex gap-3 pt-3 border-t border-gray-200">
            <button type="button" @click="showModal = false" class="flex-1 px-5 py-2.5 border border-gray-300 text-accent-black font-medium hover:bg-gray-50 transition-colors text-sm">Cancel</button>
            <button type="submit" class="flex-1 px-5 py-2.5 bg-accent-black text-white font-medium hover:bg-accent-dark transition-colors text-sm">{{ editingId ? 'Update' : 'Add' }}</button>
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
const editingId = ref(null)
const form = ref({
  name: '',
  slug: '',
  description: '',
  parent_id: null
})

const parentCategories = computed(() => {
  // Get only main categories (no parent), and exclude the one being edited
  const allCats = categories.value.map(c => c.children ? [c, ...c.children] : [c]).flat()
  return allCats.filter(c => !c.parent_id && c.id !== editingId.value)
})

onMounted(async () => {
  await loadCategories()
  await ensureDefaultCategories()
})

async function ensureDefaultCategories() {
  const defaultCategories = [
    { name: 'Eyewear', slug: 'eyewear', description: 'Koleksi kacamata premium' },
    { name: 'Accessories', slug: 'accessories', description: 'Aksesori fashion' },
    { name: 'Tops', slug: 'tops', description: 'Koleksi atasan' },
    { name: 'Bottom', slug: 'bottom', description: 'Koleksi bawahan' }
  ]
  
  for (const cat of defaultCategories) {
    // Check if category already exists
    const { data: existing } = await supabase
      .from('categories')
      .select('id')
      .eq('slug', cat.slug)
      
    if (!existing || existing.length === 0) {
      await supabase.from('categories').insert(cat)
    }
  }
  
  await loadCategories()
}

async function loadCategories() {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (error) throw error

    // Build hierarchy
    const parentCats = (data || []).filter(c => !c.parent_id)
    const childCats = (data || []).filter(c => c.parent_id)
    
    categories.value = parentCats.map(parent => ({
      ...parent,
      children: childCats.filter(child => child.parent_id === parent.id)
    }))
  } catch (error) {
    console.error('Error loading categories:', error)
  }
}

function generateSlug() {
  if (form.value.name) {
    form.value.slug = form.value.name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')
  }
}

async function saveCategory() {
  try {
    form.value.slug = form.value.slug || generateSlugFromString(form.value.name)
    
    if (editingId.value) {
      await supabase.from('categories').update(form.value).eq('id', editingId.value)
    } else {
      await supabase.from('categories').insert(form.value)
    }
    
    await loadCategories()
    showModal.value = false
    resetForm()
  } catch (error) {
    console.error('Error saving category:', error)
  }
}

async function editCategory(category) {
  editingId.value = category.id
  form.value = {
    name: category.name,
    slug: category.slug,
    description: category.description,
    parent_id: category.parent_id
  }
  showModal.value = true
}

async function deleteCategory(id) {
  if (confirm('Delete this category?')) {
    try {
      await supabase.from('categories').delete().eq('id', id)
      await loadCategories()
    } catch (error) {
      console.error('Error deleting category:', error)
    }
  }
}

function resetForm() {
  form.value = { name: '', slug: '', description: '', parent_id: null }
  editingId.value = null
}

function generateSlugFromString(name) {
  return name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')
}
</script>
