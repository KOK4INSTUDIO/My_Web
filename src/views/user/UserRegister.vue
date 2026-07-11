<template>
  <div class="min-h-screen bg-gradient-to-br from-white via-primary-50 to-white relative overflow-hidden flex items-center justify-center px-4 py-12">
    <!-- Decorative elements -->
    <div class="absolute top-0 left-0 w-80 h-80 bg-primary-200 rounded-full blur-3xl opacity-50 -translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-primary-300 rounded-full blur-3xl opacity-30 translate-x-1/3 translate-y-1/3"></div>
    
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
              <img src="/asset/logo.png" alt="KOK41NSTUDIO™" class="h-24 object-contain" />
            </div>
            <h1 class="font-display text-3xl font-bold text-accent-dark">
              Daftar Akun Baru
            </h1>
            <p class="text-accent-gray mt-2">
              Bergabunglah dengan komunitas kami!
            </p>
          </div>

          <form @submit.prevent="handleRegister" class="space-y-5">
            <!-- Error Alert -->
            <div v-if="error" class="p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">
              {{ error }}
              <div v-if="error.includes('rate limit')" class="mt-3 text-xs text-red-600 border-t border-red-100 pt-3">
                <p><strong>Cara mengatasinya:</strong></p>
                <ol class="list-decimal list-inside mt-1 space-y-1">
                  <li>Buka <a href="https://supabase.com/dashboard" target="_blank" class="underline font-medium">Supabase Dashboard</a></li>
                  <li>Pilih project Anda</li>
                  <li>Authentication → Providers → Email</li>
                  <li>Nonaktifkan "Confirm email"</li>
                  <li>Coba daftar lagi</li>
                </ol>
              </div>
            </div>
            
            <!-- Success Alert -->
            <div v-if="success" class="p-4 bg-green-50 border border-green-200 rounded-xl text-green-700 text-sm">
              {{ success }}
            </div>
            
            <!-- Confirmation Alert -->
            <div v-if="needsConfirmation" class="p-4 bg-blue-50 border border-blue-200 rounded-xl text-blue-700 text-sm">
              <p><strong>Verifikasi Email Diperlukan</strong></p>
              <p class="mt-1">Silakan cek email Anda untuk mengkonfirmasi akun.</p>
            </div>

            <!-- Name Field -->
            <div>
              <label class="block text-sm font-semibold text-accent-dark mb-2">Nama Lengkap</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">person</span>
                <input 
                  v-model="form.name"
                  type="text" 
                  required 
                  class="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all"
                  placeholder="Nama lengkap Anda"
                />
              </div>
            </div>

            <!-- Email Field -->
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

            <!-- Phone Field -->
            <div>
              <label class="block text-sm font-semibold text-accent-dark mb-2">No. WhatsApp</label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-round text-accent-gray">phone</span>
                <input 
                  v-model="form.phone"
                  type="tel" 
                  required 
                  class="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-primary-500 focus:ring-4 focus:ring-primary-100 transition-all"
                  placeholder="081234567890"
                />
              </div>
            </div>

            <!-- Password Field -->
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

            <!-- Submit Button -->
            <button 
              type="submit" 
              :disabled="authStore.loading"
              class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white font-bold rounded-xl hover:from-primary-600 hover:to-primary-700 transition-all shadow-red hover:shadow-xl transform hover:-translate-y-0.5 disabled:opacity-50 disabled:transform-none disabled:shadow-none"
            >
              <span v-if="authStore.loading" class="material-icons-round animate-spin">refresh</span>
              <span v-else class="material-icons-round">person_add</span>
              {{ authStore.loading ? 'Memproses...' : 'Daftar' }}
            </button>
          </form>

          <!-- Login Link -->
          <div class="mt-8 pt-6 border-t border-gray-100 text-center">
            <p class="text-accent-gray">
              Sudah punya akun?
              <router-link to="/user/login" class="text-primary-600 font-bold hover:text-primary-700 hover:underline ml-1">
                Masuk Sekarang
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
  name: '',
  email: '',
  phone: '',
  password: ''
})
const error = ref(null)
const success = ref(null)
const needsConfirmation = ref(false)
const showPassword = ref(false)

async function handleRegister() {
  error.value = null
  success.value = null
  needsConfirmation.value = false
  
  const result = await authStore.signUp(form.value.email, form.value.password, form.value.name, form.value.phone)
  
  if (result.success) {
    if (result.needsConfirmation) {
      needsConfirmation.value = true
    } else {
      success.value = 'Registrasi berhasil! Mengalihkan ke halaman utama...'
      setTimeout(() => {
        router.push('/home')
      }, 1500)
    }
  } else {
    error.value = result.error
  }
}
</script>
