<template>
  <div class="page-wrapper">
    <Navbar />
    
    <main class="content-container">
      <div class="catalog-header">
        <h1 class="page-title">Properti Eksklusif</h1>
        
        <!-- Minimalist Filter -->
        <div class="minimal-filter">
          <button 
            v-for="type in types" 
            :key="type.value"
            class="filter-btn"
            :class="{ active: activeFilter === type.value }"
            @click="setTypeFilter(type.value)"
          >
            {{ type.label }}
          </button>
        </div>
      </div>

      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
      </div>
      
      <div v-else-if="properties.length === 0" class="empty-state">
        <p>Belum ada properti yang tersedia untuk kategori ini.</p>
      </div>

      <div v-else class="property-grid">
        <PropertyCard 
          v-for="prop in properties" 
          :key="prop.id" 
          :property="prop" 
        />
      </div>
    </main>
    
    <div class="minimal-copyright">
      &copy; 2026 Griya Borneo Property. All rights reserved.
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { usePropertyStore } from '@/stores/propertyStore'
import Navbar from '@/components/Navbar.vue'
import Footer from '@/components/Footer.vue'
import PropertyCard from '@/components/PropertyCard.vue'

const propertyStore = usePropertyStore()

const loading = computed(() => propertyStore.loading)
const allProperties = computed(() => propertyStore.properties)

const activeFilter = ref('')

const properties = computed(() => {
  if (!activeFilter.value) return allProperties.value
  return allProperties.value.filter(p => p.property_type === activeFilter.value)
})

const types = [
  { label: 'Semua Tipe', value: '' },
  { label: 'Subsidi', value: 'subsidi' },
  { label: 'Komersil', value: 'commercial' },
  { label: 'Cluster', value: 'cluster' },
  { label: 'Ruko', value: 'ruko' }
]

const setTypeFilter = (val) => {
  activeFilter.value = val
}

onMounted(async () => {
  await propertyStore.fetchProperties({ isPublished: true })
})
</script>

<style scoped>
.page-wrapper {
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.content-container {
  flex: 1;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 100px 2rem 0; /* space for navbar */
  display: flex;
  flex-direction: column;
}

.catalog-header {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-bottom: 2rem;
  flex-shrink: 0;
}

.page-title {
  font-size: clamp(2.5rem, 4vw, 3.5rem);
  letter-spacing: -0.02em;
}

.minimal-filter {
  display: flex;
  gap: 2rem;
  overflow-x: auto;
  padding-bottom: 1rem;
  scrollbar-width: none;
}
.minimal-filter::-webkit-scrollbar {
  display: none;
}
.filter-btn {
  font-size: 1rem;
  color: var(--c-text-muted);
  font-weight: 500;
  padding-bottom: 0.5rem;
  position: relative;
  white-space: nowrap;
}
.filter-btn:hover {
  color: var(--c-text-main);
}
.filter-btn.active {
  color: var(--c-primary-dark);
}
.filter-btn.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: var(--c-primary-dark);
}

.property-grid {
  display: flex;
  gap: 2rem;
  overflow-x: auto;
  overflow-y: hidden;
  padding-bottom: 2rem;
  scroll-snap-type: x mandatory;
  scrollbar-width: thin;
}
.property-grid > * {
  flex-shrink: 0;
  width: 320px;
  scroll-snap-align: start;
}

.loading-state, .empty-state {
  text-align: center;
  padding: 4rem 0;
  color: var(--c-text-muted);
}
.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(16, 185, 129, 0.2);
  border-top-color: var(--c-primary);
  border-radius: 50%;
  animation: spin 1s infinite linear;
  margin: 0 auto 1rem;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}

.minimal-copyright {
  text-align: center;
  color: var(--c-text-muted);
  font-size: 0.875rem;
  padding: 10rem;
  margin-top: auto;
}
</style>
