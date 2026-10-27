<template>
  <div class="split-layout" v-if="property">
    <!-- Left Panel: Image Gallery (Shared Element) -->
    <div class="left-panel bg-surface-alt">
      <button class="back-btn" @click="goBack" title="Kembali">
        <ArrowLeftIcon size="24" />
      </button>
      
      <div class="main-image-container" v-if="property.images && property.images.length">
        <transition name="gallery-fade" mode="out-in">
          <img 
            :key="currentImageIndex"
            :src="formatImageUrl(property.images[currentImageIndex])" 
            :alt="`${property.title} - Foto ${currentImageIndex + 1}`"
            class="main-image"
            :style="currentImageIndex === 0 ? `view-transition-name: property-img-${property.id}` : ''"
            @touchstart="onTouchStart"
            @touchend="onTouchEnd"
          />
        </transition>

        <!-- Navigation Arrows (if > 1 image) -->
        <template v-if="property.images && property.images.length > 1">
          <button class="nav-btn prev-btn" @click="prevImage" title="Foto Sebelumnya">
            <ChevronLeftIcon size="24" />
          </button>
          <button class="nav-btn next-btn" @click="nextImage" title="Foto Berikutnya">
            <ChevronRightIcon size="24" />
          </button>

          <!-- Counter Badge -->
          <div class="image-counter">
            {{ currentImageIndex + 1 }} / {{ property.images.length }}
          </div>
        </template>
      </div>
      
      <!-- Minimalist thumbnail selector if >1 image -->
      <div class="thumbnail-list" v-if="property.images && property.images.length > 1">
        <button 
          v-for="(img, idx) in property.images" 
          :key="idx"
          class="thumb-btn"
          :class="{ active: currentImageIndex === idx }"
          @click="currentImageIndex = idx"
        >
          <img :src="formatImageUrl(img)" :alt="`Thumbnail ${idx + 1}`" />
        </button>
      </div>
    </div>
    
    <!-- Right Panel: Content -->
    <div class="right-panel">
      <div class="content-scroll" style="view-transition-name: detail-content">
        <div class="header-section">
          <h1 class="property-title" :style="`view-transition-name: property-title-${property.id}`">
            {{ property.title }}
          </h1>
          <p class="property-price" :style="`view-transition-name: property-price-${property.id}`">
            {{ formatPrice(property.discount_price || property.price) }}
            <span v-if="property.discount_price" class="original-price">{{ formatPrice(property.price) }}</span>
          </p>
          <div class="location">
            <MapPinIcon size="18" /> {{ property.address }}, {{ property.city }}
          </div>
        </div>
        
        <div class="specs-grid">
          <div class="spec-item" v-if="property.bedrooms">
            <BedIcon size="24" class="spec-icon" />
            <div class="spec-text">
              <span class="spec-val">{{ property.bedrooms }}</span>
              <span class="spec-label">Kamar Tidur</span>
            </div>
          </div>
          <div class="spec-item" v-if="property.bathrooms">
            <BathIcon size="24" class="spec-icon" />
            <div class="spec-text">
              <span class="spec-val">{{ property.bathrooms }}</span>
              <span class="spec-label">Kamar Mandi</span>
            </div>
          </div>
          <div class="spec-item" v-if="property.building_area">
            <MaximizeIcon size="24" class="spec-icon" />
            <div class="spec-text">
              <span class="spec-val">{{ property.building_area }} m²</span>
              <span class="spec-label">Luas Bangunan</span>
            </div>
          </div>
          <div class="spec-item" v-if="property.land_area">
            <MaximizeIcon size="24" class="spec-icon" />
            <div class="spec-text">
              <span class="spec-val">{{ property.land_area }} m²</span>
              <span class="spec-label">Luas Tanah</span>
            </div>
          </div>
        </div>
        
        <div class="description-section">
          <h3>Tentang Properti</h3>
          <p class="desc-text">{{ property.description || 'Tidak ada deskripsi.' }}</p>
        </div>
        
        <div class="facilities-section" v-if="property.facilities && property.facilities.length">
          <h3>Fasilitas</h3>
          <ul class="facility-list">
            <li v-for="(fac, idx) in property.facilities" :key="idx">
              <CheckCircleIcon size="18" class="text-primary" /> {{ fac }}
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Floating Circular WhatsApp Button (Pojok Kanan Bawah) -->
    <button class="whatsapp-circle-btn" style="left: auto; right: 2rem;" @click="contactAgent" title="Hubungi Agen via WhatsApp">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
        <path d="M12.031 6.172c-3.181 0-5.767 2.586-5.768 5.766-.001 1.298.38 2.27 1.019 3.287l-.582 2.128 2.182-.573c.978.58 1.911.928 3.145.929 3.178 0 5.767-2.587 5.768-5.766.001-3.187-2.575-5.77-5.764-5.771zm3.392 8.244c-.144.405-.837.774-1.17.824-.299.045-.677.063-1.092-.069-.252-.08-.575-.187-.988-.365-1.739-.751-2.874-2.502-2.961-2.617-.087-.116-.708-.94-.708-1.793s.448-1.273.607-1.446c.159-.173.346-.217.462-.217l.332.006c.106.005.249-.04.39.298.144.347.491 1.2.534 1.287.043.087.072.188.014.304-.058.116-.087.188-.173.289l-.26.304c-.087.086-.177.18-.076.354.101.174.449.741.964 1.201.662.591 1.221.774 1.394.86s.274.072.376-.043c.101-.116.433-.506.549-.68.116-.173.231-.145.39-.087s1.011.477 1.184.564c.173.087.289.129.332.202.043.073.043.423-.101.827z"/>
        <path d="M12.031 2C6.495 2 2 6.494 2 12.031c0 1.769.462 3.496 1.34 5.019L2 22l5.088-1.332A9.976 9.976 0 0012.031 22c5.535 0 9.999-4.494 9.999-10.03S17.566 2 12.031 2zm0 18.256c-1.503 0-2.973-.404-4.262-1.168l-.306-.182-3.167.83.844-3.088-.2-.317A8.251 8.251 0 013.743 12.03c0-4.57 3.719-8.289 8.288-8.289 4.57 0 8.288 3.719 8.288 8.289s-3.719 8.29-8.288 8.29z"/>
      </svg>
      <span class="wa-tooltip">Hubungi via WhatsApp</span>
    </button>
  </div>
  
  <div v-else class="loading-full">
    <div class="spinner"></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { useSettingStore } from '@/stores/settingStore'
import { formatPrice, formatImageUrl } from '@/utils/formatters'
import { 
  ArrowLeft as ArrowLeftIcon, 
  MapPin as MapPinIcon, 
  Bed as BedIcon, 
  Bath as BathIcon, 
  Maximize as MaximizeIcon,
  CheckCircle as CheckCircleIcon,
  ChevronLeft as ChevronLeftIcon,
  ChevronRight as ChevronRightIcon
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const settingStore = useSettingStore()

const property = ref(null)
const currentImageIndex = ref(0)
const touchStartX = ref(0)
const touchEndX = ref(0)

onMounted(async () => {
  const { data } = await supabase
    .from('properties')
    .select('*')
    .eq('slug', route.params.slug)
    .single()
    
  if (data) {
    property.value = data
    currentImageIndex.value = 0
  }
  
  await settingStore.fetchSettings()
})

const nextImage = () => {
  if (!property.value?.images?.length) return
  currentImageIndex.value = (currentImageIndex.value + 1) % property.value.images.length
}

const prevImage = () => {
  if (!property.value?.images?.length) return
  currentImageIndex.value = (currentImageIndex.value - 1 + property.value.images.length) % property.value.images.length
}

const onTouchStart = (e) => {
  touchStartX.value = e.changedTouches[0].screenX
}

const onTouchEnd = (e) => {
  touchEndX.value = e.changedTouches[0].screenX
  handleSwipe()
}

const handleSwipe = () => {
  const diff = touchEndX.value - touchStartX.value
  if (Math.abs(diff) > 40) { // threshold
    if (diff > 0) {
      prevImage()
    } else {
      nextImage()
    }
  }
}

const goBack = () => {
  router.push('/')
}

const contactAgent = () => {
  if (!property.value) return
  let num = property.value.whatsapp_number || settingStore.settings['whatsapp_number'] || '6281234567890'
  const message = `Halo, saya tertarik dengan properti "${property.value.title}". Apakah masih tersedia?`
  const url = `https://wa.me/${num}?text=${encodeURIComponent(message)}`
  window.open(url, '_blank')
}
</script>

<style scoped>
.split-layout {
  display: flex;
  min-height: 100vh;
  flex-direction: column;
}

@media (min-width: 992px) {
  .split-layout {
    flex-direction: row;
    height: 100vh;
    overflow: hidden;
  }
}

.left-panel {
  position: relative;
  background-color: var(--c-surface-alt);
  padding: 5rem 1.5rem 2rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 1.5rem;
  overflow: hidden;
}
@media (min-width: 992px) {
  .left-panel {
    width: 50%;
    padding: 2rem 4rem;
  }
}

.back-btn {
  position: absolute;
  top: 2rem;
  left: 2rem;
  width: 48px;
  height: 48px;
  background: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-sm);
  color: var(--c-text-main);
  transition: all 0.2s;
  z-index: 20;
}
.back-btn:hover {
  transform: translateX(-5px);
  box-shadow: var(--shadow);
}

/* Image Container with Nav & Counter */
.main-image-container {
  position: relative;
  width: 100%;
  max-width: 580px;
  aspect-ratio: 4/3;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-lg);
  background: #000;
  display: flex;
  align-items: center;
  justify-content: center;
}
.main-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  user-select: none;
}

/* Gallery Fade Animation (Smooth & Lightweight) */
.gallery-fade-enter-active,
.gallery-fade-leave-active {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.gallery-fade-enter-from {
  opacity: 0;
  transform: scale(0.98);
}
.gallery-fade-leave-to {
  opacity: 0;
  transform: scale(1.02);
}

/* Arrow Navigation */
.nav-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 42px;
  height: 42px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(6px);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--c-text-main);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  transition: all 0.2s ease;
  z-index: 10;
  border: 1px solid rgba(255, 255, 255, 0.5);
}
.nav-btn:hover {
  background: white;
  transform: translateY(-50%) scale(1.08);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.28);
}
.prev-btn { left: 1rem; }
.next-btn { right: 1rem; }

/* Counter Badge */
.image-counter {
  position: absolute;
  bottom: 1rem;
  right: 1rem;
  background: rgba(0, 0, 0, 0.65);
  backdrop-filter: blur(6px);
  color: white;
  font-size: 0.8rem;
  font-weight: 500;
  padding: 0.35rem 0.75rem;
  border-radius: 20px;
  letter-spacing: 0.5px;
  z-index: 10;
}

/* Thumbnail List */
.thumbnail-list {
  display: flex;
  gap: 0.75rem;
  overflow-x: auto;
  max-width: 580px;
  padding: 0.25rem 0.25rem 0.75rem;
  scrollbar-width: thin;
  width: 100%;
}
.thumb-btn {
  width: 72px;
  height: 52px;
  border-radius: var(--radius-sm);
  overflow: hidden;
  opacity: 0.5;
  transition: all 0.2s ease;
  flex-shrink: 0;
  border: 2px solid transparent;
}
.thumb-btn.active, .thumb-btn:hover {
  opacity: 1;
  transform: scale(1.05);
  border-color: var(--c-primary);
  box-shadow: var(--shadow-sm);
}
.thumb-btn img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.right-panel {
  background-color: white;
  padding: 2rem;
  position: relative;
}
@media (min-width: 992px) {
  .right-panel {
    width: 50%;
    padding: 0;
  }
}

.content-scroll {
  height: 100%;
  max-width: 600px;
  margin: 0 auto;
}
@media (min-width: 992px) {
  .content-scroll {
    overflow-y: auto;
    padding: 3rem 4rem 8rem;
  }
}

.header-section {
  margin-bottom: 2rem;
}
.property-title {
  font-size: clamp(1.8rem, 2.5vw, 2.6rem);
  line-height: 1.15;
  margin-bottom: 0.75rem;
  letter-spacing: -0.02em;
}
.property-price {
  font-size: 1.4rem;
  font-weight: 600;
  color: var(--c-primary);
  margin-bottom: 0.75rem;
}
.original-price {
  font-size: 1rem;
  color: var(--c-text-muted);
  text-decoration: line-through;
  font-weight: 400;
  margin-left: 0.75rem;
}
.location {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--c-text-muted);
  font-size: 0.95rem;
}

.specs-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  margin-bottom: 2.5rem;
  padding: 1.5rem 0;
  border-top: 1px solid var(--c-border);
  border-bottom: 1px solid var(--c-border);
}
.spec-item {
  display: flex;
  align-items: center;
  gap: 0.85rem;
}
.spec-icon {
  color: var(--c-primary);
}
.spec-text {
  display: flex;
  flex-direction: column;
}
.spec-val {
  font-weight: 600;
  font-size: 1.05rem;
}
.spec-label {
  font-size: 0.825rem;
  color: var(--c-text-muted);
}

.description-section h3, .facilities-section h3 {
  font-size: 1.15rem;
  font-weight: 600;
  margin-bottom: 0.85rem;
  color: var(--c-text-main);
}
.desc-text {
  color: var(--c-text-muted);
  white-space: pre-line;
  line-height: 1.7;
  font-size: 0.95rem;
}

.facilities-section {
  margin-top: 2.5rem;
}
.facility-list {
  list-style: none;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.85rem;
  font-size: 0.95rem;
}
.facility-list li {
  display: flex;
  align-items: center;
  gap: 0.65rem;
  color: var(--c-text-main);
}
.text-primary { color: var(--c-primary); }

/* Floating Circular WhatsApp Button (Kanan Bawah) */
.whatsapp-circle-btn {
  position: fixed !important;
  bottom: 2rem !important;
  right: 2rem !important;
  left: auto !important;
  width: 58px;
  height: 58px;
  background-color: #25D366;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 14px rgba(37, 211, 102, 0.45);
  z-index: 1000;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: none;
  cursor: pointer;
}
.whatsapp-circle-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 20px rgba(37, 211, 102, 0.65);
  background-color: #22c35e;
}
.wa-tooltip {
  position: absolute;
  right: 72px;
  background-color: #1e293b;
  color: white;
  padding: 0.5rem 0.85rem;
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: 500;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transform: translateX(10px);
  transition: all 0.25s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}
.whatsapp-circle-btn:hover .wa-tooltip {
  opacity: 1;
  transform: translateX(0);
}

@media (max-width: 768px) {
  .whatsapp-circle-btn {
    bottom: 1.5rem !important;
    right: 1.5rem !important;
    left: auto !important;
    width: 54px;
    height: 54px;
  }
}

.loading-full {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.spinner {
  width: 48px;
  height: 48px;
  border: 4px solid var(--c-border);
  border-top-color: var(--c-primary);
  border-radius: 50%;
  animation: spin 1s infinite linear;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
