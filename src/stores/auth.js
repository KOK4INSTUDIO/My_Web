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

  async function signUp(email, password, name, phone) {
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            name,
            phone
          },
          emailRedirectTo: window.location.origin + '/home'
        }
      })
      if (error) throw error
      
      // If user is returned immediately (email confirmation disabled), set user
      if (data.user) {
        user.value = data.user
        return { success: true, needsConfirmation: false }
      }
      
      // If email confirmation is required
      return { 
        success: true, 
        needsConfirmation: true,
        message: 'Registrasi berhasil! Silakan cek email untuk verifikasi.'
      }
    } catch (error) {
      // Handle rate limit error specifically
      if (error.message?.includes('rate limit')) {
        return { 
          success: false, 
          error: 'Batas pengiriman email terlampaui. Silakan nonaktifkan verifikasi email di Supabase Dashboard atau coba lagi nanti.'
        }
      }
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
    return !!session
  }

  return {
    user,
    loading,
    signIn,
    signUp,
    signOut,
    checkSession
  }
})