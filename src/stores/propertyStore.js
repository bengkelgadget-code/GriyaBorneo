import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'

export const usePropertyStore = defineStore('property', () => {
  const properties = ref([])
  const loading = ref(false)
  const currentProperty = ref(null)

  async function fetchProperties(filters = {}) {
    loading.value = true
    let query = supabase
      .from('properties')
      .select('*')
      .order('created_at', { ascending: false })

    if (filters.isPublished !== undefined) {
      query = query.eq('is_published', filters.isPublished)
    }
    if (filters.type) {
      query = query.eq('property_type', filters.type)
    }
    if (filters.status) {
      query = query.eq('status', filters.status)
    }
    if (filters.isFeatured !== undefined) {
      query = query.eq('is_featured', filters.isFeatured)
    }

    const { data, error } = await query
    loading.value = false
    
    if (error) throw error
    properties.value = data
    return data
  }

  async function fetchPropertyBySlug(slug) {
    loading.value = true
    const { data, error } = await supabase
      .from('properties')
      .select('*')
      .eq('slug', slug)
      .single()
    
    loading.value = false
    if (error) throw error
    currentProperty.value = data
    return data
  }
  
  async function fetchPropertyById(id) {
    loading.value = true
    const { data, error } = await supabase
      .from('properties')
      .select('*')
      .eq('id', id)
      .single()
    
    loading.value = false
    if (error) throw error
    currentProperty.value = data
    return data
  }

  async function saveProperty(propertyData) {
    if (propertyData.id) {
      // Update
      const { data, error } = await supabase
        .from('properties')
        .update(propertyData)
        .eq('id', propertyData.id)
        .select()
      if (error) throw error
      return data[0]
    } else {
      // Insert
      const { data, error } = await supabase
        .from('properties')
        .insert([propertyData])
        .select()
      if (error) throw error
      return data[0]
    }
  }

  async function deleteProperty(id) {
    const { error } = await supabase
      .from('properties')
      .delete()
      .eq('id', id)
    if (error) throw error
    properties.value = properties.value.filter(p => p.id !== id)
  }

  return {
    properties,
    loading,
    currentProperty,
    fetchProperties,
    fetchPropertyBySlug,
    fetchPropertyById,
    saveProperty,
    deleteProperty
  }
})
