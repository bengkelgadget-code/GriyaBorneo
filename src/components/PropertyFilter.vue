<template>
  <div class="property-filter glass">
    <div class="filter-group">
      <label class="filter-label">Tipe Properti</label>
      <select v-model="filters.type" class="filter-select" @change="emitFilter">
        <option value="">Semua Tipe</option>
        <option value="subsidi">Subsidi</option>
        <option value="commercial">Commercial / Non-Subsidi</option>
        <option value="cluster">Cluster</option>
        <option value="ruko">Ruko</option>
      </select>
    </div>

    <div class="filter-group">
      <label class="filter-label">Status</label>
      <select v-model="filters.status" class="filter-select" @change="emitFilter">
        <option value="">Semua Status</option>
        <option value="available">Tersedia</option>
        <option value="promo">Promo</option>
        <option value="sold">Terjual</option>
      </select>
    </div>

    <button class="btn btn-outline reset-btn" @click="resetFilter">Reset</button>
  </div>
</template>

<script setup>
import { reactive } from 'vue'

const emit = defineEmits(['filter-change'])

const filters = reactive({
  type: '',
  status: ''
})

const emitFilter = () => {
  emit('filter-change', { ...filters })
}

const resetFilter = () => {
  filters.type = ''
  filters.status = ''
  emitFilter()
}
</script>

<style scoped>
.property-filter {
  display: flex;
  gap: 1.5rem;
  align-items: flex-end;
  padding: 1.5rem;
  border-radius: var(--radius);
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  min-width: 200px;
  flex: 1;
}

.filter-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--c-text-main);
}

.filter-select {
  padding: 0.75rem 1rem;
  border: 1px solid var(--c-border);
  border-radius: var(--radius-sm);
  background: white;
  font-family: inherit;
  color: var(--c-text-main);
  outline: none;
  transition: border-color 0.2s;
}
.filter-select:focus {
  border-color: var(--c-primary);
}

.reset-btn {
  height: 46px;
}

@media (max-width: 768px) {
  .property-filter {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
