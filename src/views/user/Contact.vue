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
              <a href="https://www.instagram.com/kok41nstudio?igsh=Z2xuam1qc3pxcWZt" target="_blank" class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center text-gray-600 hover:bg-accent-black hover:text-white transition-all">
                <img src="/asset/instagram.png" alt="Instagram" class="w-6 h-6 object-contain" />
              </a>
              <a href="https://www.tiktok.com/@kok4instudio?_r=1&_t=ZS-97Lirab1chB" target="_blank" class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center transition-all hover:bg-accent-black">
                <img src="/asset/tiktok.png" alt="TikTok" class="w-6 h-6 object-contain" />
              </a>
              <a href="https://shopee.co.id/kok4instudio" target="_blank" class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center transition-all hover:bg-accent-black">
                <img src="/asset/shopee.png" alt="Shopee" class="w-6 h-6 object-contain" />
              </a>
              <a href="https://wa.me/6289501798516" target="_blank" class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center text-gray-600 hover:bg-accent-black hover:text-white transition-all">
                <img src="/asset/whatsapp.png" alt="Whatsapp" class="w-6 h-6 object-contain" />
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
            <!-- Success Message -->
            <div v-if="showSuccess" class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg flex items-center gap-2">
              <span class="material-icons-round">check_circle</span>
              <span>Terima kasih! Pesan Anda telah terkirim.</span>
            </div>
            
            <button
              type="submit"
              :disabled="isSending"
              class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-primary-600 text-white font-medium hover:bg-primary-800 transition-colors rounded-lg disabled:opacity-70 disabled:cursor-not-allowed"
            >
              <span v-if="isSending" class="material-icons-round animate-spin">refresh</span>
              <span v-else class="material-icons-round">send</span>
              {{ isSending ? 'Mengirim...' : 'Kirim Pesan' }}
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useContactStore } from '@/stores/contact'
import emailjs from '@emailjs/browser'

const contactStore = useContactStore()
const isSending = ref(false)
const showSuccess = ref(false)

const form = ref({
  name: '',
  email: '',
  subject: 'Pertanyaan Produk',
  message: ''
})

async function submitForm() {
  isSending.value = true
  
  // Save to store
  contactStore.addMessage({
    name: form.value.name,
    email: form.value.email,
    subject: form.value.subject,
    message: form.value.message
  })

  try {
    // EmailJS configuration - Anda perlu mendaftar di https://www.emailjs.com/ untuk mendapatkan credentials ini
    const serviceID = 'YOUR_SERVICE_ID' // Ganti dengan Service ID Anda
    const templateID = 'YOUR_TEMPLATE_ID' // Ganti dengan Template ID Anda
    const publicKey = 'YOUR_PUBLIC_KEY' // Ganti dengan Public Key Anda

    // Template parameters
    const templateParams = {
      from_name: form.value.name,
      from_email: form.value.email,
      subject: form.value.subject,
      message: form.value.message
    }

    if (serviceID !== 'YOUR_SERVICE_ID' && templateID !== 'YOUR_TEMPLATE_ID' && publicKey !== 'YOUR_PUBLIC_KEY') {
      await emailjs.send(serviceID, templateID, templateParams, publicKey)
      showSuccess.value = true
      form.value = { name: '', email: '', subject: 'Pertanyaan Produk', message: '' }
      setTimeout(() => { showSuccess.value = false }, 5000)
    } else {
      // Fallback ke mailto jika EmailJS belum dikonfigurasi
      const subject = encodeURIComponent(form.value.subject)
      const body = encodeURIComponent(`Nama: ${form.value.name}\nEmail: ${form.value.email}\n\nPesan:\n${form.value.message}`)
      window.location.href = `mailto:kok4instudio@gmail.com?subject=${subject}&body=${body}`
    }
  } catch (error) {
    console.error('Error sending email:', error)
    alert('Gagal mengirim pesan. Silakan coba lagi.')
  } finally {
    isSending.value = false
  }
}
</script>
