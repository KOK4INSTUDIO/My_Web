<template>
  <div class="space-y-5">
    <h3 class="font-display text-lg font-bold text-black">Social Media & Links</h3>

    <!-- WhatsApp Configuration -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2 text-sm">
          💬 WhatsApp
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">WhatsApp Number</label>
          <input v-model="social.whatsapp_number" type="tel" placeholder="6281234567890" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          <p class="text-gray-500 text-[10px] mt-1">Use country code without + (e.g., 6281234567890)</p>
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Default Order Message Template</label>
          <textarea v-model="social.whatsapp_template" rows="4" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs" placeholder="Halo, saya ingin pesan produk..."></textarea>
          <p class="text-gray-500 text-[10px] mt-1">Available variables: {product_name}, {product_url}, {price}</p>
        </div>
        <div class="bg-gray-100 p-3 rounded-lg text-xs">
          <p class="text-gray-600 mb-1 text-[10px]">Preview:</p>
          <p class="text-black text-xs">{{ previewWhatsapp }}</p>
        </div>
      </div>
    </div>

    <!-- Other Social Links -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2 text-sm">
          🔗 Social Links
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-bold text-black mb-1">Instagram</label>
            <input v-model="social.instagram" type="url" placeholder="https://instagram.com/..." class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Facebook</label>
            <input v-model="social.facebook" type="url" placeholder="https://facebook.com/..." class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Tokopedia</label>
            <input v-model="social.tokopedia" type="url" placeholder="https://tokopedia.com/..." class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          </div>
          <div>
            <label class="block text-xs font-bold text-black mb-1">Shopee</label>
            <input v-model="social.shopee" type="url" placeholder="https://shopee.com/..." class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
          </div>
        </div>
      </div>
    </div>

    <!-- Contact Info -->
    <div class="bg-white border-2 border-black rounded-lg shadow-sm overflow-hidden">
      <div class="p-4 border-b-2 border-black bg-gray-50">
        <h4 class="font-bold text-black flex items-center gap-2 text-sm">
          📞 Contact Information
        </h4>
      </div>
      <div class="p-4 space-y-4">
        <div>
          <label class="block text-xs font-bold text-black mb-1">Email</label>
          <input v-model="social.email" type="email" placeholder="hello@kok4instudio.com" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Phone</label>
          <input v-model="social.phone" type="tel" placeholder="+62 812 3456 7890" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs">
        </div>
        <div>
          <label class="block text-xs font-bold text-black mb-1">Address</label>
          <textarea v-model="social.address" rows="3" class="w-full px-3 py-2 border-2 border-black focus:outline-none focus:ring-2 focus:ring-red-500 rounded-lg text-xs" placeholder="Jl. Contoh No. 123..."></textarea>
        </div>
      </div>
    </div>

    <div class="flex justify-end">
      <button @click="saveSettings" class="px-4 py-2.5 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition-colors shadow-md text-xs">Save Changes</button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const social = ref({
  whatsapp_number: '',
  whatsapp_template: 'Halo, saya ingin pesan {product_name} dengan harga {price}. Apakah masih available?',
  instagram: '',
  facebook: '',
  tokopedia: '',
  shopee: '',
  email: '',
  phone: '',
  address: ''
})

const previewWhatsapp = computed(() => {
  return social.value.whatsapp_template
    .replace('{product_name}', '[Nama Produk]')
    .replace('{product_url}', '[Link Produk]')
    .replace('{price}', 'Rp 199.000')
})

function saveSettings() {
  console.log('Saving social settings:', social.value)
  alert('Settings saved successfully!')
}
</script>
