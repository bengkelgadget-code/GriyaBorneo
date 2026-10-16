import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const session = ref(null)
  const loading = ref(true)

  async function checkSession() {
    loading.value = true
    const { data } = await supabase.auth.getSession()
    session.value = data.session
    user.value = data.session?.user || null
    loading.value = false
  }

  async function login(identifier, password) {
    let email = identifier.trim()
    if (!email.includes('@')) {
      const cleanPhone = email.replace(/[^0-9]/g, '')
      email = `${cleanPhone}@griyaborneo.id`
    }
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    if (error) throw error
    user.value = data.user
    session.value = data.session
    return data
  }

  async function logout() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    user.value = null
    session.value = null
  }

  // Setup listener for auth state changes
  supabase.auth.onAuthStateChange((_event, _session) => {
    session.value = _session
    user.value = _session?.user || null
  })

  return { user, session, loading, checkSession, login, logout }
})
