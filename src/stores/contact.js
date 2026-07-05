import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useContactStore = defineStore('contact', () => {
  const messages = ref([])

  function addMessage(message) {
    messages.value.unshift({
      id: Date.now(),
      ...message,
      createdAt: new Date().toISOString()
    })
  }

  function deleteMessage(id) {
    messages.value = messages.value.filter(msg => msg.id !== id)
  }

  return { messages, addMessage, deleteMessage }
})
