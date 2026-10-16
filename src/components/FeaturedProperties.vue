<template>
  <section class="featured-section">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Properti Unggulan</h2>
        <p class="section-subtitle">Pilihan terbaik untuk investasi dan hunian masa depan Anda.</p>
      </div>

      <div v-if="loading" class="loading-state">
        <p>Memuat properti unggulan...</p>
      </div>
      
      <div v-else-if="properties.length === 0" class="empty-state">
        <p>Belum ada properti unggulan saat ini.</p>
      </div>

      <div v-else class="property-grid">
        <PropertyCard 
          v-for="prop in properties" 
          :key="prop.id" 
          :property="prop" 
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { usePropertyStore } from '@/stores/propertyStore'
import PropertyCard from './PropertyCard.vue'

const propertyStore = usePropertyStore()
const properties = computed(() => propertyStore.properties.filter(p => p.is_featured && p.is_published).slice(0, 3))
const loading = computed(() => propertyStore.loading)
</script>

<style scoped>
.featured-section {
  padding: 5rem 0;
  background-color: white;
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
}

.section-title {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.section-subtitle {
  color: var(--c-text-muted);
  font-size: 1.125rem;
}

.property-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 2rem;
}

.loading-state, .empty-state {
  text-align: center;
  padding: 3rem;
  color: var(--c-text-muted);
}
</style>
