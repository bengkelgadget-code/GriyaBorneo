<template>
  <div class="dashboard-page">
    <div class="page-header">
      <div>
        <h1 class="page-title">Dashboard Properti</h1>
        <p class="text-muted">Kelola semua properti katalog Anda.</p>
      </div>
      <router-link to="/kelola-griya/property/new" class="btn btn-primary">
        <PlusIcon size="18" /> Tambah Properti
      </router-link>
    </div>
    
    <!-- Summary Cards -->
    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon bg-primary-light"><HomeIcon /></div>
        <div class="summary-info">
          <span class="summary-label">Total Properti</span>
          <span class="summary-value">{{ properties.length }}</span>
        </div>
      </div>
      <div class="summary-card">
        <div class="summary-icon bg-success-light"><CheckCircleIcon /></div>
        <div class="summary-info">
          <span class="summary-label">Tersedia</span>
          <span class="summary-value">{{ availableCount }}</span>
        </div>
      </div>
      <div class="summary-card">
        <div class="summary-icon bg-danger-light"><TagIcon /></div>
        <div class="summary-info">
          <span class="summary-label">Terjual</span>
          <span class="summary-value">{{ soldCount }}</span>
        </div>
      </div>
    </div>
    
    <!-- Data Table -->
    <div class="table-container">
      <div v-if="loading" class="text-center p-8">
        <div class="spinner inline-block"></div>
        <p class="mt-2 text-muted">Memuat data properti...</p>
      </div>
      
      <table v-else class="data-table">
        <thead>
          <tr>
            <th>Properti</th>
            <th>Tipe & Status</th>
            <th>Harga</th>
            <th>Publikasi</th>
            <th class="text-right">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="properties.length === 0">
            <td colspan="5" class="text-center text-muted p-8">Belum ada data properti.</td>
          </tr>
          <tr v-for="prop in properties" :key="prop.id">
            <td>
              <div class="flex items-center gap-4">
                <div class="thumbnail">
                  <img :src="prop.images?.[0] || 'https://via.placeholder.com/80'" alt="thumb" />
                </div>
                <div>
                  <div class="font-semibold">{{ prop.title }}</div>
                  <div class="text-xs text-muted">{{ prop.city }}</div>
                </div>
              </div>
            </td>
            <td>
              <div class="mb-1 text-sm uppercase text-muted font-semibold">{{ prop.property_type }}</div>
              <span class="badge" :class="getStatusClass(prop.status)">
                {{ getStatusText(prop.status) }}
              </span>
            </td>
            <td>
              <div class="font-semibold text-primary">{{ formatPrice(prop.discount_price || prop.price) }}</div>
              <div v-if="prop.discount_price" class="text-xs text-muted line-through">{{ formatPrice(prop.price) }}</div>
            </td>
            <td>
              <span class="badge" :class="prop.is_published ? 'badge-success' : 'badge-draft'">
                {{ prop.is_published ? 'Publik' : 'Draft' }}
              </span>
              <span v-if="prop.is_featured" class="badge badge-featured ml-2" title="Featured">⭐</span>
            </td>
            <td class="text-right">
              <div class="action-buttons">
                <router-link :to="`/kelola-griya/property/${prop.id}/edit`" class="btn-icon btn-edit" title="Edit">
                  <EditIcon size="18" />
                </router-link>
                <button class="btn-icon btn-delete" title="Hapus" @click="confirmDelete(prop)">
                  <Trash2Icon size="18" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <ConfirmDialog 
      :show="showDeleteConfirm"
      title="Hapus Properti"
      :message="`Apakah Anda yakin ingin menghapus properti '${propertyToDelete?.title}'? Data yang dihapus tidak dapat dikembalikan.`"
      confirmText="Ya, Hapus"
      confirmBtnClass="btn-danger"
      @confirm="handleDelete"
      @cancel="showDeleteConfirm = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { usePropertyStore } from '@/stores/propertyStore'
import { formatPrice } from '@/utils/formatters'
import ConfirmDialog from '@/components/ConfirmDialog.vue'
import { 
  Plus as PlusIcon,
  Home as HomeIcon,
  CheckCircle as CheckCircleIcon,
  Tag as TagIcon,
  Edit as EditIcon,
  Trash2 as Trash2Icon
} from 'lucide-vue-next'

const propertyStore = usePropertyStore()

const loading = computed(() => propertyStore.loading)
const properties = computed(() => propertyStore.properties)

const availableCount = computed(() => properties.value.filter(p => p.status === 'available' || p.status === 'promo').length)
const soldCount = computed(() => properties.value.filter(p => p.status === 'sold').length)

const showDeleteConfirm = ref(false)
const propertyToDelete = ref(null)

onMounted(async () => {
  await propertyStore.fetchProperties() // Fetch all without filters for admin
})

const getStatusClass = (status) => {
  switch (status) {
    case 'available': return 'badge-available'
    case 'sold': return 'badge-sold'
    case 'promo': return 'badge-promo'
    default: return 'badge-draft'
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 'available': return 'Tersedia'
    case 'sold': return 'Terjual'
    case 'promo': return 'Promo'
    default: return 'Draft'
  }
}

const confirmDelete = (prop) => {
  propertyToDelete.value = prop
  showDeleteConfirm.value = true
}

const handleDelete = async () => {
  if (!propertyToDelete.value) return
  
  try {
    await propertyStore.deleteProperty(propertyToDelete.value.id)
    showDeleteConfirm.value = false
    propertyToDelete.value = null
  } catch (error) {
    alert('Gagal menghapus properti')
    console.error(error)
  }
}
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}
.page-title {
  font-size: 2rem;
  margin-bottom: 0.25rem;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}
.summary-card {
  background: white;
  padding: 1.5rem;
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  display: flex;
  align-items: center;
  gap: 1.5rem;
  border: 1px solid var(--c-border);
}
.summary-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}
.bg-primary-light { background: rgba(16, 185, 129, 0.1); color: var(--c-primary); }
.bg-success-light { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
.bg-danger-light { background: rgba(239, 68, 68, 0.1); color: var(--c-danger); }
.summary-info {
  display: flex;
  flex-direction: column;
}
.summary-label {
  color: var(--c-text-muted);
  font-size: 0.875rem;
}
.summary-value {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--c-text-main);
  line-height: 1.2;
}

.table-container {
  background: white;
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--c-border);
  overflow-x: auto;
}
.data-table {
  width: 100%;
  border-collapse: collapse;
}
.data-table th, .data-table td {
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid var(--c-border);
  text-align: left;
}
.data-table th {
  background-color: #f8fafc;
  font-weight: 600;
  color: var(--c-text-muted);
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
}
.data-table tr:last-child td {
  border-bottom: none;
}
.data-table tbody tr:hover {
  background-color: #f8fafc;
}

.thumbnail {
  width: 64px;
  height: 48px;
  border-radius: var(--radius-sm);
  overflow: hidden;
  background-color: #e2e8f0;
}
.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: var(--radius-sm);
  font-size: 0.75rem;
  font-weight: 600;
}
.badge-available { background: rgba(16, 185, 129, 0.1); color: var(--c-success); }
.badge-sold { background: rgba(239, 68, 68, 0.1); color: var(--c-danger); }
.badge-promo { background: rgba(245, 158, 11, 0.1); color: var(--c-warning); }
.badge-draft { background: rgba(100, 116, 139, 0.1); color: var(--c-text-muted); }
.badge-success { background: rgba(16, 185, 129, 0.1); color: var(--c-success); }
.badge-featured { background: transparent; }

.action-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 0.5rem;
}
.btn-icon {
  width: 36px;
  height: 36px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  background: white;
  border: 1px solid var(--c-border);
}
.btn-edit { color: var(--c-info); }
.btn-edit:hover { background: rgba(59, 130, 246, 0.1); border-color: rgba(59, 130, 246, 0.3); }
.btn-delete { color: var(--c-danger); }
.btn-delete:hover { background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.3); }

/* Utilities */
.text-muted { color: var(--c-text-muted); }
.text-center { text-align: center; }
.text-right { text-align: right; }
.text-xs { font-size: 0.75rem; }
.text-sm { font-size: 0.875rem; }
.font-semibold { font-weight: 600; }
.text-primary { color: var(--c-primary); }
.uppercase { text-transform: uppercase; }
.flex { display: flex; }
.items-center { align-items: center; }
.gap-4 { gap: 1rem; }
.mb-1 { margin-bottom: 0.25rem; }
.ml-2 { margin-left: 0.5rem; }
.line-through { text-decoration: line-through; }
.p-8 { padding: 2rem; }
.mt-2 { margin-top: 0.5rem; }
.inline-block { display: inline-block; }
.spinner {
  width: 24px;
  height: 24px;
  border: 3px solid rgba(16, 185, 129, 0.3);
  border-radius: 50%;
  border-top-color: var(--c-primary);
  animation: spin 1s ease-in-out infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
