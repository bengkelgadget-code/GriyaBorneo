import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

export const useSettingStore = defineStore('setting', () => {
  const settings = ref({})
  const loading = ref(false)

  async function fetchSettings() {
    loading.value = true
    const { data, error } = await supabase
      .from('app_settings')
      .select('*')
    
    loading.value = false
    if (error) throw error
    
    const settingsObj = {}
    data.forEach(item => {
      settingsObj[item.id] = item.value
    })
    settings.value = settingsObj
    return settingsObj
  }

  async function saveSetting(id, value, description = '') {
    const { error } = await supabase
      .from('app_settings')
      .upsert({ id, value, description, updated_at: new Date().toISOString() })
    
    if (error) throw error
    settings.value[id] = value
  }

  return {
    settings,
    loading,
    fetchSettings,
    saveSetting
  }
})
