<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-semibold text-brand-black">Registration Log</h3>
    </div>

    <!-- Registration Log Table -->
    <div class="bg-brand-white border border-brand-border overflow-x-auto">
      <table class="w-full">
        <thead>
          <tr>
            <th class="table-header">Timestamp</th>
            <th class="table-header">Email</th>
            <th class="table-header">User ID</th>
            <th class="table-header">Created At</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id" class="table-row">
            <td class="px-4 py-3 text-brand-medium text-sm">
              {{ new Date(user.created_at).toLocaleString('id-ID') }}
            </td>
            <td class="px-4 py-3 text-brand-black">{{ user.email || '-' }}</td>
            <td class="px-4 py-3 text-brand-medium text-sm font-mono">{{ user.id?.slice(0, 12) || '-' }}</td>
            <td class="px-4 py-3 text-brand-medium text-sm">
              {{ new Date(user.created_at).toLocaleDateString('id-ID') }}
            </td>
          </tr>
          <tr v-if="users.length === 0">
            <td colspan="4" class="px-6 py-8 text-center text-brand-medium">
              No registration logs found
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-between text-sm text-brand-medium">
      <span>Showing {{ users.length }} entries</span>
      <div class="flex gap-2">
        <button class="px-3 py-1 border border-brand-border hover:bg-brand-surface">Prev</button>
        <button class="px-3 py-1 border border-brand-border hover:bg-brand-surface">Next</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const users = ref([])

onMounted(async () => {
  // Mock data untuk Registration Log
  users.value = [
    {
      id: 'user-123',
      email: 'user1@example.com',
      created_at: new Date(Date.now() - 1000 * 60 * 30)
    },
    {
      id: 'user-456',
      email: 'user2@example.com',
      created_at: new Date(Date.now() - 1000 * 60 * 60 * 2)
    },
    {
      id: 'user-789',
      email: 'user3@example.com',
      created_at: new Date(Date.now() - 1000 * 60 * 60 * 24)
    }
  ]
})
</script>
