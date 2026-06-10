import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'
import { ref } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const loading = ref(false)

  async function signIn(email, password) {
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })
      if (error) throw error
      user.value = data.user
      return { success: true }
    } catch (error) {
      return { success: false, error: error.message }
    } finally {
      loading.value = false
    }
  }

  async function signOut() {
    await supabase.auth.signOut()
    user.value = null
  }

  async function checkSession() {
    const { data: { session } } = await supabase.auth.getSession()
    user.value = session?.user || null
  }

  return {
    user,
    loading,
    signIn,
    signOut,
    checkSession
  }
})