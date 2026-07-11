<template>
  <div class="min-h-screen bg-gradient-to-br from-white via-primary-50 to-white relative overflow-hidden flex items-center justify-center px-4 py-12">
    <!-- Decorative elements -->
    <div class="absolute top-0 right-0 w-80 h-80 bg-primary-200 rounded-full blur-3xl opacity-50 translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-primary-300 rounded-full blur-3xl opacity-30 -translate-x-1/2 translate-y-1/2"></div>
    
    <div class="relative z-10 max-w-md w-full">
      <div class="relative">
        <div class="absolute -inset-1 bg-gradient-to-r from-primary-500 to-primary-600 rounded-3xl blur opacity-25"></div>
        <div class="relative bg-white p-8 md:p-10 rounded-3xl shadow-xl border border-primary-100">
          <!-- Back Button -->
          <router-link to="/" class="inline-flex items-center gap-2 text-accent-gray hover:text-primary-600 transition-colors mb-6">
            <span class="material-icons-round text-xl">arrow_back</span>
            <span class="font-medium">Kembali</span>
          </router-link>
          
          <!-- Header -->
          <div class="text-center mb-8">
            <div class="flex items-center justify-center mx-auto mb-4">
              <img src="/asset/logo.png" alt="KOK41STUDIO" class="h-24 object-contain" />
            </div>
            <h1 class="font-display text-3xl font-bold text-accent-dark">
              Masuk ke Akun
            </h1>
            <p class="text-accent-gray mt-2">
              Masuk untuk melanjutkan pengalaman belanja
            </p>
          </div>

          <form @submit.prevent="handleLogin" class="space-y-6">
            <div v-if="error" class="p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">
              {{ error }}
            </div>
            <div>
              <label class="block text-sm font-semibold text-accent-dark mb-2">Email</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">email</span>
                <input 
                  v-model="form.email"
                  type="email" 
                  required 
                  class="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all"
                  placeholder="email@example.com"
                />
              </div>
            </div>
            <div>
              <label class="block text-sm font-semibold text-accent-dark mb-2">Password</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">lock</span>
                <input 
                  v-model="form.password"
                  :type="showPassword ? 'text' : 'password'" 
                  required 
                  class="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all"
                  placeholder="••••••••"
                />
                <button 
                  type="button"
                  @click="showPassword = !showPassword"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-accent-gray hover:text-primary-600 transition-colors"
                >
                  <span class="material-icons-round">{{ showPassword ? 'visibility_off' : 'visibility' }}</span>
                </button>
              </div>
            </div>
            <button 
              type="submit" 
              :disabled="authStore.loading"
              class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-bold rounded-xl hover:from-primary-600 hover:to-primary-700 transition-all shadow-red hover:shadow-xl transform hover:-translate-y-0.5 disabled:opacity-50 disabled:transform-none disabled:shadow-none"
            >
              <span v-if="authStore.loading" class="material-icons-round animate-spin">refresh</span>
              <span v-else class="material-icons-round">login</span>
              {{ authStore.loading ? 'Memproses...' : 'Masuk' }}
            </button>
          </form>

          <div class="mt-8 pt-6 border-t border-gray-100 text-center">
            <p class="text-accent-gray">
              Belum punya akun?
              <router-link to="/user/register" class="text-primary-600 font-bold hover:text-primary-700 hover:underline ml-1">
                Daftar Sekarang
              </router-link>
            </p>
          </div>
        </div>
      </div>
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
const error = ref(null)
const showPassword = ref(false)

async function handleLogin() {
  error.value = null
  const result = await authStore.signIn(form.value.email, form.value.password)
  if (result.success) {
    router.push('/home')
  } else {
    error.value = result.error
  }
}
</script>
