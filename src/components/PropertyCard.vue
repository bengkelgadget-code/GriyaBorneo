<template>
  <router-link :to="`/property/${property.slug}`" class="property-card">
    <div class="image-wrapper">
      <img 
        :src="formatImageUrl(property.images?.[0])" 
        :alt="property.title"
        class="property-image"
        :style="`view-transition-name: property-img-${property.id}`"
      />
      <!-- Optional: Badges floating on image if needed, but video was very clean -->
    </div>
    
    <div class="card-content">
      <h3 class="property-title" :style="`view-transition-name: property-title-${property.id}`">
        {{ property.title }}
      </h3>
      <p class="property-price" :style="`view-transition-name: property-price-${property.id}`">
        {{ formatPrice(property.discount_price || property.price) }}
      </p>
    </div>
  </router-link>
</template>

<script setup>
import { formatPrice, formatImageUrl } from '@/utils/formatters'

defineProps({
  property: {
    type: Object,
    required: true
  }
})
</script>

<style scoped>
.property-card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  background: transparent;
  text-decoration: none;
  cursor: pointer;
  group: hover;
  transition: transform 0.3s ease;
}

.property-card:hover .property-image {
  transform: scale(1.02);
}

.image-wrapper {
  position: relative;
  width: 100%;
  aspect-ratio: 4 / 3;
  overflow: hidden;
  border-radius: var(--radius-lg);
  background: var(--c-surface-alt);
}

.property-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  /* The view-transition-name is dynamically injected via inline style */
}

.card-content {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 0 0.5rem;
}

.property-title {
  font-family: var(--font-body);
  font-size: 1.125rem;
  font-weight: 500;
  color: var(--c-text-main);
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.property-price {
  font-family: var(--font-body);
  font-size: 1rem;
  font-weight: 400;
  color: var(--c-text-muted);
  margin: 0;
}
</style>
