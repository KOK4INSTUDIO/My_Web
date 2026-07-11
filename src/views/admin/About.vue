<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <h3 class="font-display text-xl font-bold text-accent-black">About Page</h3>
      <button @click="saveAbout" class="flex items-center justify-center gap-2 px-5 py-2.5 bg-accent-black text-white font-medium hover:bg-accent-dark transition-colors text-sm">
        <span class="material-icons-round text-lg">save</span>
        Simpan Perubahan
      </button>
    </div>

    <div class="bg-white border border-gray-200 rounded-lg p-6 space-y-6">
      <div>
        <label class="block text-sm font-bold text-gray-700 mb-2">Judul</label>
        <input
          v-model="aboutData.title"
          type="text"
          class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm"
        >
      </div>

      <div>
        <label class="block text-sm font-bold text-gray-700 mb-2">Konten About</label>
        <textarea
          v-model="aboutData.content1"
          rows="4"
          class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm"
        ></textarea>
      </div>

      <div>
        <label class="block text-sm font-bold text-gray-700 mb-2">Konten Lanjutan (opsional)</label>
        <textarea
          v-model="aboutData.content2"
          rows="4"
          class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm"
        ></textarea>
      </div>

      <div>
        <label class="block text-sm font-bold text-gray-700 mb-2">Konten Akhir (opsional)</label>
        <textarea
          v-model="aboutData.content3"
          rows="4"
          class="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:border-accent-black transition-colors text-sm"
        ></textarea>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const aboutData = ref({
  id: 'about_content',
  title: 'Tentang KOK41NSTUDIO™',
  content1: 'KOK41NSTUDIO™ adalah brand fashion yang lahir dari semangat untuk terus berkarya dan menghadirkan produk berkualitas bagi setiap pelanggan. Kami baru memulai perjalanan di dunia fashion, namun kami memiliki komitmen yang kuat untuk menghasilkan berbagai produk custom yang dibuat dengan perhatian terhadap detail, kualitas, dan identitas yang khas.',
  content2: 'Setiap produk yang kami hadirkan dirancang untuk memberikan kenyamanan, nilai estetika, serta karakter yang dapat mewakili gaya dan kepribadian penggunanya. Kami percaya bahwa sebuah produk tidak hanya sekadar pakaian atau aksesori, tetapi juga menjadi bagian dari identitas dan ekspresi diri.',
  content3: 'Dengan mengutamakan kualitas bahan, proses produksi yang teliti, serta pelayanan terbaik, KOK41NSTUDIO™ terus berupaya berkembang dan menghadirkan karya-karya yang dapat dibanggakan. Terima kasih telah menjadi bagian dari perjalanan kami dalam menciptakan produk fashion yang autentik dan bernilai.'
})

async function saveAbout() {
  try {
    const { data, error } = await supabase
      .from('site_settings')
      .upsert(aboutData.value)
      .select()

    if (error) throw error
    alert('About content berhasil disimpan!')
  } catch (error) {
    console.error('Error saving about content:', error)
    alert('Gagal menyimpan. Pastikan tabel site_settings sudah dibuat di Supabase.')
  }
}

async function loadAbout() {
  try {
    const { data } = await supabase
      .from('site_settings')
      .select('*')
      .eq('id', 'about_content')
      .single()

    if (data) {
      // Replace old brand name with new one
      const updatedData = {
        ...data,
        title: data.title?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™'),
        content1: data.content1?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™'),
        content2: data.content2?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™'),
        content3: data.content3?.replace(/KOK4INSTUDIO|KOK41STUDIO/g, 'KOK41NSTUDIO™')
      }
      aboutData.value = updatedData
    }
  } catch (error) {
    console.error('Error loading about content:', error)
  }
}

onMounted(() => {
  loadAbout()
})
</script>
