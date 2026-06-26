<template>
  <div class="min-h-screen">
    <!-- Debug info (hanya untuk development) -->
    <div class="p-4 bg-yellow-100 text-xs">
      <strong>Debug Info:</strong><br>
      Supabase URL: {{ supabaseUrl || 'TIDAK ADA!' }}<br>
      Supabase Key: {{ supabaseKey ? 'ADA' : 'TIDAK ADA!' }}
    </div>
    <router-view />
  </div>
</template>

<script setup>
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
</script>