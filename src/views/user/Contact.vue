<template>
  <div class="py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Hero -->
      <div class="text-center mb-16">
        <h1 class="font-display text-3xl md:text-5xl font-bold text-accent-black mb-4">Hubungi Kami</h1>
        <p class="text-gray-600 max-w-2xl mx-auto text-lg">Ada pertanyaan atau ingin kolaborasi? Kami siap membantu Anda.</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <!-- Contact Info -->
        <div>
          <h2 class="font-display text-2xl font-bold text-accent-black mb-8">Informasi Kontak</h2>
          <div class="space-y-6">
            <div class="flex items-start gap-4">
              <div class="w-12 h-12 bg-accent-light rounded-full flex items-center justify-center flex-shrink-0">
                <span class="material-icons-round text-accent-black">location_on</span>
              </div>
              <div>
                <h3 class="font-medium text-accent-black mb-1">Alamat</h3>
                <p class="text-gray-600">Jl. Suryakencana, Kp.Pamuruyan, Kec. Cibadak, Kabupaten Sukabumi, Jawa Barat 43351</p>
              </div>
            </div>

            <div class="flex items-start gap-4">
              <div class="w-12 h-12 bg-accent-light rounded-full flex items-center justify-center flex-shrink-0">
                <span class="material-icons-round text-accent-black">mail</span>
              </div>
              <div>
                <h3 class="font-medium text-accent-black mb-1">Email</h3>
                <a href="mailto:kok4instudio@gmail.com" class="text-gray-600 hover:text-accent-black transition-colors">
                  kok4instudio@gmail.com
                </a>
              </div>
            </div>

            <div class="flex items-start gap-4">
              <div class="w-12 h-12 bg-accent-light rounded-full flex items-center justify-center flex-shrink-0">
                <span class="material-icons-round text-accent-black">phone</span>
              </div>
              <div>
                <h3 class="font-medium text-accent-black mb-1">WhatsApp</h3>
                <a href="https://wa.me/6289501798516" target="_blank" class="text-gray-600 hover:text-accent-black transition-colors">
                  +62 895-0179-8516
                </a>
              </div>
            </div>
          </div>

          <!-- Social Media -->
          <div class="mt-12">
            <h3 class="font-medium text-accent-black mb-4">Ikuti Kami</h3>
            <div class="flex gap-4">
              <a href="https://www.instagram.com/kok41nstudio?igsh=Z2xuam1qc3pxcWZt" target="_blank" class="social-btn w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center hover:bg-gradient-to-br hover:from-purple-600 hover:to-pink-500 transition-all duration-300 hover:scale-110 hover:shadow-lg">
                <img src="/asset/instagram.png" alt="Instagram" class="social-icon w-6 h-6 object-contain transition-all duration-300" />
              </a>
              <a href="https://www.tiktok.com/@kok4instudio?_r=1&_t=ZS-97Lirab1chB" target="_blank" class="social-btn w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center hover:bg-accent-black transition-all duration-300 hover:scale-110 hover:shadow-lg">
                <img src="/asset/tiktok.png" alt="TikTok" class="social-icon w-6 h-6 object-contain transition-all duration-300" />
              </a>
              <a href="https://shopee.co.id/kok4instudio" target="_blank" class="social-btn w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center hover:bg-orange-500 transition-all duration-300 hover:scale-110 hover:shadow-lg">
                <img src="/asset/shopee.png" alt="Shopee" class="social-icon w-6 h-6 object-contain transition-all duration-300" />
              </a>
              <a href="https://wa.me/6289501798516" target="_blank" class="social-btn w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center hover:bg-green-500 transition-all duration-300 hover:scale-110 hover:shadow-lg">
                <img src="/asset/whatsapp.png" alt="Whatsapp" class="social-icon w-6 h-6 object-contain transition-all duration-300" />
              </a>
            </div>
          </div>
        </div>

        <!-- Contact Form -->
        <div class="bg-gray-50 p-8 rounded-2xl">
          <h2 class="font-display text-2xl font-bold text-accent-black mb-8">Kirim Pesan</h2>
          <form @submit.prevent="submitForm" class="space-y-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Nama Lengkap</label>
              <input
                v-model="form.name"
                type="text"
                required
                class="w-full px-4 py-3 border border-gray-300 bg-white focus:outline-none focus:border-accent-black transition-colors rounded-lg"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
              <input
                v-model="form.email"
                type="email"
                required
                class="w-full px-4 py-3 border border-gray-300 bg-white focus:outline-none focus:border-accent-black transition-colors rounded-lg"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Subjek</label>
              <select
                v-model="form.subject"
                class="w-full px-4 py-3 border border-gray-300 bg-white focus:outline-none focus:border-accent-black transition-colors rounded-lg"
              >
                <option>Pertanyaan Produk</option>
                <option>Pemesanan</option>
                <option>Kolaborasi</option>
                <option>Lainnya</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Pesan</label>
              <textarea
                v-model="form.message"
                rows="5"
                required
                class="w-full px-4 py-3 border border-gray-300 bg-white focus:outline-none focus:border-accent-black transition-colors rounded-lg resize-none"
              ></textarea>
            </div>
            <button
              type="submit"
              class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-primary-600 text-white font-medium hover:bg-primary-800 transition-colors rounded-lg"
            >
              <span class="material-icons-round">send</span>
              Kirim Pesan
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const form = ref({
  name: '',
  email: '',
  subject: 'Pertanyaan Produk',
  message: ''
})

function submitForm() {
  alert(`Terima kasih ${form.value.name}! Pesan Anda telah terkirim. Kami akan segera menghubungi Anda.`)
  form.value = { name: '', email: '', subject: 'Pertanyaan Produk', message: '' }
}
</script>

<style scoped>
.social-icon {
  filter: brightness(0) saturate(100%) invert(45%) sepia(0%) saturate(0%) hue-rotate(0deg) brightness(95%) contrast(85%);
}

.social-btn:hover .social-icon {
  filter: brightness(0) saturate(100%) invert(100%) sepia(0%) saturate(7500%) hue-rotate(244deg) brightness(117%) contrast(116%);
}
</style>
