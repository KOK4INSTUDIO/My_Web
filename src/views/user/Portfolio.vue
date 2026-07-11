<template>
  <div class="py-16">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
      <h1 class="font-display text-2xl md:text-3xl font-bold text-accent-dark mb-6">{{ aboutData.title }}</h1>
      <p class="text-accent-gray text-lg leading-relaxed mb-6" v-if="aboutData.content1">
        {{ aboutData.content1 }}
      </p>
      <p class="text-accent-gray text-lg leading-relaxed mb-6" v-if="aboutData.content2">
        {{ aboutData.content2 }}
      </p>
      <p class="text-accent-gray text-lg leading-relaxed" v-if="aboutData.content3">
        {{ aboutData.content3 }}
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const aboutData = ref({
  title: 'About KOK41NSTUDIO™',
  content1: 'KOK41NSTUDIO™ adalah brand fashion yang lahir dari semangat untuk terus berkarya dan menghadirkan produk berkualitas bagi setiap pelanggan. Kami baru memulai perjalanan di dunia fashion, namun kami memiliki komitmen yang kuat untuk menghasilkan berbagai produk custom yang dibuat dengan perhatian terhadap detail, kualitas, dan identitas yang khas.',
  content2: 'Setiap produk yang kami hadirkan dirancang untuk memberikan kenyamanan, nilai estetika, serta karakter yang dapat mewakili gaya dan kepribadian penggunanya. Kami percaya bahwa sebuah produk tidak hanya sekadar pakaian atau aksesori, tetapi juga menjadi bagian dari identitas dan ekspresi diri.',
  content3: 'Dengan mengutamakan kualitas bahan, proses produksi yang teliti, serta pelayanan terbaik, KOK41NSTUDIO™ terus berupaya berkembang dan menghadirkan karya-karya yang dapat dibanggakan. Terima kasih telah menjadi bagian dari perjalanan kami dalam menciptakan produk fashion yang autentik dan bernilai.'
})

onMounted(async () => {
  await loadAbout()
})

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
</script>
