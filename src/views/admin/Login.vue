<template>
  <div class="min-h-screen bg-white flex items-center justify-center p-4">
    <div class="w-full max-w-sm">
      <!-- Logo -->
      <div class="text-center mb-6">
        <img 
          src="https://i.imgur.com/l3v0q5b.png" 
          alt="KOK4INSTUDIO Logo" 
          class="mx-auto mb-4 w-full max-w-xs"
        />
        <p class="text-gray-500 text-sm">Sign in to your admin dashboard</p>
      </div>
      
      <!-- Login Card -->
      <div class="bg-white border-2 border-black rounded-xl shadow-md p-5">
        <form @submit.prevent="handleLogin" class="space-y-4">
          <!-- Email -->
          <div class="space-y-2">
            <label class="block text-sm font-semibold text-black flex items-center gap-2">
              <span class="material-icons-round text-lg text-red-600">email</span>
              Email Address
            </label>
            <div class="relative">
              <input
                v-model="form.email"
                type="email"
                required
                class="w-full pl-12 pr-4 py-2.5 border-2 border-black rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 bg-white"
                :class="{ 'border-red-600 bg-red-50 focus:ring-red-600': error }"
                placeholder="admin@kok4instudio.com"
              />
              <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">
                alternate_email
              </span>
            </div>
          </div>
          
          <!-- Password -->
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <label class="block text-sm font-semibold text-black flex items-center gap-2">
                <span class="material-icons-round text-lg text-red-600">lock</span>
                Password
              </label>
            </div>
            <div class="relative">
              <input
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                class="w-full pl-12 pr-12 py-2.5 border-2 border-black rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500 bg-white"
                :class="{ 'border-red-600 bg-red-50 focus:ring-red-600': error }"
                placeholder="••••••••"
              />
              <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">
                key
              </span>
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-black transition-colors"
              >
                <span class="material-icons-round text-xl">
                  {{ showPassword ? 'visibility_off' : 'visibility' }}
                </span>
              </button>
            </div>
          </div>
          
          <!-- Error Alert -->
          <div v-if="error" class="bg-red-50 border-2 border-red-600 rounded-lg p-3 flex items-start gap-2">
            <span class="material-icons-round text-red-600 shrink-0 mt-0.5">error</span>
            <div>
              <p class="font-semibold text-red-800 text-sm">Login Failed</p>
              <p class="text-xs text-red-700 mt-0.5">{{ error }}</p>
            </div>
          </div>
          
          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full bg-red-600 text-white px-5 py-3 font-semibold rounded-lg flex items-center justify-center gap-2 transition-all hover:bg-red-700 active:scale-[0.97] shadow-md"
          >
            <span v-if="loading" class="material-icons-round animate-spin">refresh</span>
            <span v-else class="material-icons-round">login</span>
            {{ loading ? 'Signing in...' : 'Sign In' }}
          </button>
        </form>
      </div>

      <!-- Footer -->
      <p class="text-center text-gray-400 text-xs mt-5">
        © 2024 KOK4INSTUDIO. All rights reserved.
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  email: '',
  password: ''
})
const loading = ref(false)
const error = ref(null)
const showPassword = ref(false)

async function handleLogin() {
  loading.value = true
  error.value = null
  
  const result = await authStore.signIn(form.value.email, form.value.password)
  
  if (result.success) {
    router.push('/admin')
  } else {
    error.value = result.error || 'Email atau password salah'
  }
  
  loading.value = false
}
</script>
