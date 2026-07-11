<template>
  <div class="min-h-screen bg-gradient-to-br from-white via-primary-50 to-white relative overflow-hidden flex items-center justify-center p-4">
    <!-- Decorative elements -->
    <div class="absolute top-0 right-0 w-96 h-96 bg-primary-200 rounded-full blur-3xl opacity-50 translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-primary-300 rounded-full blur-3xl opacity-30 -translate-x-1/2 translate-y-1/2"></div>
    
    <div class="relative z-10 w-full max-w-sm">
      <!-- Logo -->
      <div class="text-center mb-8">
        <div class="w-20 h-20 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-red">
          <span class="material-icons-round text-white text-4xl">admin_panel_settings</span>
        </div>
        <h1 class="font-display text-2xl font-bold text-accent-dark">Admin Dashboard</h1>
        <p class="text-accent-gray text-sm mt-2">Sign in to your admin account</p>
      </div>
      
      <!-- Login Card -->
      <div class="relative">
        <div class="absolute -inset-1 bg-gradient-to-r from-primary-500 to-primary-600 rounded-3xl blur opacity-25"></div>
        <div class="relative bg-white p-8 rounded-3xl shadow-xl border border-primary-100">
          <form @submit.prevent="handleLogin" class="space-y-5">
            <!-- Email -->
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-accent-dark">Email Address</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">email</span>
                <input
                  v-model="form.email"
                  type="email"
                  required
                  class="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all bg-white"
                  :class="{ 'border-red-600 bg-red-50 focus:ring-red-100': error }"
                  placeholder="admin@kok4instudio.com"
                />
              </div>
            </div>
            
            <!-- Password -->
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-accent-dark">Password</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">lock</span>
                <input
                  v-model="form.password"
                  :type="showPassword ? 'text' : 'password'"
                  required
                  class="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all bg-white"
                  :class="{ 'border-red-600 bg-red-50 focus:ring-red-100': error }"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  @click="showPassword = !showPassword"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-accent-gray hover:text-primary-600 transition-colors"
                >
                  <span class="material-icons-round text-xl">
                    {{ showPassword ? 'visibility_off' : 'visibility' }}
                  </span>
                </button>
              </div>
            </div>
            
            <!-- Error Alert -->
            <div v-if="error" class="p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">
              <div class="flex items-start gap-2">
                <span class="material-icons-round text-red-600 shrink-0">error</span>
                <div>
                  <p class="font-semibold">Login Failed</p>
                  <p class="text-xs mt-0.5">{{ error }}</p>
                </div>
              </div>
            </div>
            
            <!-- Submit Button -->
            <button
              type="submit"
              :disabled="loading"
              class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-bold rounded-xl hover:from-primary-600 hover:to-primary-700 transition-all shadow-red hover:shadow-xl transform hover:-translate-y-0.5 disabled:opacity-50 disabled:transform-none disabled:shadow-none"
            >
              <span v-if="loading" class="material-icons-round animate-spin">refresh</span>
              <span v-else class="material-icons-round">login</span>
              {{ loading ? 'Signing in...' : 'Sign In' }}
            </button>
          </form>
        </div>
      </div>

      <!-- Footer -->
      <p class="text-center text-gray-500 text-xs mt-6">
        © 2026 KOK41STUDIO. All rights reserved.
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
