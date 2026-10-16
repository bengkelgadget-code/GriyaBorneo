<template>
  <div class="form-page">
    <div class="page-header">
      <div>
        <router-link to="/kelola-griya" class="back-link">&larr; Kembali ke Dashboard</router-link>
        <h1 class="page-title">{{ isEdit ? 'Edit Properti' : 'Tambah Properti Baru' }}</h1>
      </div>
    </div>
    
    <div v-if="loadingInit" class="loading-state">
      Memuat data...
    </div>
    
    <form v-else @submit.prevent="handleSubmit" class="form-container">
      <div class="main-column">
        <!-- Basic Info -->
        <div class="card">
          <h3 class="card-title">Informasi Dasar</h3>
          
          <div class="form-group">
            <label class="form-label">Judul Properti *</label>
            <input type="text" v-model="formData.title" class="form-control" required placeholder="Contoh: Rumah Tipe 45 Cluster Emerald" />
          </div>
          
          <div class="form-group">
            <label class="form-label">Deskripsi Lengkap</label>
            <textarea v-model="formData.description" class="form-control" rows="6" placeholder="Deskripsikan properti ini..."></textarea>
          </div>
          
          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Tipe Properti *</label>
              <select v-model="formData.property_type" class="form-control" required>
                <option value="subsidi">Subsidi</option>
                <option value="commercial">Commercial</option>
                <option value="cluster">Cluster</option>
                <option value="ruko">Ruko</option>
              </select>
            </div>
            
            <div class="form-group">
              <label class="form-label">Status *</label>
              <select v-model="formData.status" class="form-control" required>
                <option value="available">Tersedia</option>
                <option value="promo">Promo</option>
                <option value="sold">Terjual</option>
              </select>
            </div>
          </div>
        </div>
        
        <!-- Pricing -->
        <div class="card">
          <h3 class="card-title">Harga</h3>
          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Harga Normal (Rp) *</label>
              <input type="number" v-model="formData.price" class="form-control" required min="0" />
            </div>
            <div class="form-group">
              <label class="form-label">Harga Promo (Rp) - Opsional</label>
              <input type="number" v-model="formData.discount_price" class="form-control" min="0" />
            </div>
          </div>
        </div>
        
        <!-- Specs -->
        <div class="card">
          <h3 class="card-title">Spesifikasi</h3>
          <div class="grid-3">
            <div class="form-group">
              <label class="form-label">Kamar Tidur</label>
              <input type="number" v-model="formData.bedrooms" class="form-control" min="0" />
            </div>
            <div class="form-group">
              <label class="form-label">Kamar Mandi</label>
              <input type="number" v-model="formData.bathrooms" class="form-control" min="0" />
            </div>
            <div class="form-group">
              <label class="form-label">Jumlah Lantai</label>
              <input type="number" v-model="formData.floors" class="form-control" min="1" />
            </div>
            <div class="form-group">
              <label class="form-label">Luas Tanah (m²)</label>
              <input type="number" v-model="formData.land_area" class="form-control" min="0" />
            </div>
            <div class="form-group">
              <label class="form-label">Luas Bangunan (m²)</label>
              <input type="number" v-model="formData.building_area" class="form-control" min="0" />
            </div>
            <div class="form-group">
              <label class="form-label">Sertifikat</label>
              <select v-model="formData.certificate" class="form-control">
                <option value="SHM">SHM (Hak Milik)</option>
                <option value="SHGB">SHGB (Hak Guna Bangunan)</option>
                <option value="AJB">AJB</option>
                <option value="Lainnya">Lainnya</option>
              </select>
            </div>
          </div>
        </div>
        
        <!-- Location -->
        <div class="card">
          <h3 class="card-title">Lokasi</h3>
          <div class="form-group">
            <label class="form-label">Alamat Lengkap</label>
            <input type="text" v-model="formData.address" class="form-control" />
          </div>
          <div class="form-group">
            <label class="form-label">Kota / Area</label>
            <input type="text" v-model="formData.city" class="form-control" />
          </div>
          <div class="form-group">
            <label class="form-label">URL Embed Google Maps (Opsional)</label>
            <textarea v-model="formData.maps_url" class="form-control" rows="3" placeholder="<iframe src='...'></iframe>"></textarea>
          </div>
        </div>
        
        <!-- Facilities -->
        <div class="card">
          <h3 class="card-title">Fasilitas Tambahan</h3>
          <div class="form-group">
            <div class="flex gap-2 mb-2">
              <input type="text" v-model="newFacility" class="form-control" placeholder="Contoh: Carport, Taman Depan" @keyup.enter.prevent="addFacility" />
              <button type="button" class="btn btn-outline" @click="addFacility">Tambah</button>
            </div>
            <div class="facility-chips">
              <div v-for="(fac, idx) in formData.facilities" :key="idx" class="chip">
                {{ fac }}
                <button type="button" class="chip-delete" @click="removeFacility(idx)">&times;</button>
              </div>
            </div>
          </div>
        </div>
        
      </div>
      
      <div class="side-column">
        <!-- Media Uploader -->
        <div class="card">
          <h3 class="card-title">Foto Properti</h3>
          <ImageUploader v-model="formData.images" />
        </div>
        
        <!-- Publish Settings -->
        <div class="card">
          <h3 class="card-title">Pengaturan Publikasi</h3>
          
          <div class="toggle-group">
            <label class="toggle-label">Publikasikan</label>
            <label class="switch">
              <input type="checkbox" v-model="formData.is_published">
              <span class="slider round"></span>
            </label>
          </div>
          <p class="help-text">Jika dimatikan, properti hanya tersimpan sebagai draft.</p>
          
          <div class="toggle-group mt-4">
            <label class="toggle-label">Jadikan Unggulan</label>
            <label class="switch">
              <input type="checkbox" v-model="formData.is_featured">
              <span class="slider round"></span>
            </label>
          </div>
          <p class="help-text">Akan ditampilkan di section "Properti Unggulan" halaman depan.</p>
        </div>
        
        <!-- Contact Override -->
        <div class="card">
          <h3 class="card-title">Kontak Agen (Opsional)</h3>
          <p class="help-text mb-2">Biarkan kosong untuk menggunakan nomor WA default sistem.</p>
          <div class="form-group mb-0">
            <input type="text" v-model="formData.whatsapp_number" class="form-control" placeholder="6281..." />
          </div>
        </div>
        
        <!-- Actions -->
        <div class="action-panel">
          <button type="submit" class="btn btn-primary btn-block btn-lg" :disabled="saving">
            {{ saving ? 'Menyimpan...' : (isEdit ? 'Simpan Perubahan' : 'Terbitkan Properti') }}
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { usePropertyStore } from '@/stores/propertyStore'
import { generateSlug } from '@/utils/formatters'
import ImageUploader from '@/components/ImageUploader.vue'

const router = useRouter()
const route = useRoute()
const propertyStore = usePropertyStore()

const isEdit = ref(false)
const loadingInit = ref(false)
const saving = ref(false)

const newFacility = ref('')

const formData = ref({
  title: '',
  description: '',
  property_type: 'subsidi',
  status: 'available',
  price: null,
  discount_price: null,
  bedrooms: 0,
  bathrooms: 0,
  floors: 1,
  land_area: 0,
  building_area: 0,
  certificate: 'SHM',
  address: '',
  city: '',
  maps_url: '',
  facilities: [],
  images: [],
  is_published: true,
  is_featured: false,
  whatsapp_number: ''
})

onMounted(async () => {
  if (route.params.id) {
    isEdit.value = true
    loadingInit.value = true
    try {
      const prop = await propertyStore.fetchPropertyById(route.params.id)
      formData.value = { ...prop }
    } catch (error) {
      alert('Gagal memuat data properti')
      router.push('/kelola-griya')
    } finally {
      loadingInit.value = false
    }
  }
})

const addFacility = () => {
  const fac = newFacility.value.trim()
  if (fac && !formData.value.facilities.includes(fac)) {
    formData.value.facilities.push(fac)
  }
  newFacility.value = ''
}

const removeFacility = (idx) => {
  formData.value.facilities.splice(idx, 1)
}

const handleSubmit = async () => {
  saving.value = true
  
  // Format data before saving
  const dataToSave = { ...formData.value }
  if (!isEdit.value) {
    dataToSave.slug = generateSlug(dataToSave.title) + '-' + Math.random().toString(36).substring(2, 6)
  }
  
  // Ensure numeric fields are numbers or null
  dataToSave.price = dataToSave.price ? Number(dataToSave.price) : 0
  dataToSave.discount_price = dataToSave.discount_price ? Number(dataToSave.discount_price) : null
  
  try {
    await propertyStore.saveProperty(dataToSave)
    router.push('/kelola-griya')
  } catch (error) {
    console.error(error)
    alert('Gagal menyimpan data: ' + (error.message || error.details || JSON.stringify(error)))
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.form-page {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 2rem;
}
.back-link {
  color: var(--c-primary);
  font-size: 0.875rem;
  font-weight: 500;
  display: inline-block;
  margin-bottom: 0.5rem;
}
.back-link:hover { text-decoration: underline; }
.page-title {
  font-size: 2rem;
}

.form-container {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}
@media (min-width: 992px) {
  .form-container {
    grid-template-columns: 2fr 1fr;
  }
}

.card {
  background: white;
  padding: 1.5rem;
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--c-border);
  margin-bottom: 1.5rem;
}
.card-title {
  margin-bottom: 1.5rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid var(--c-border);
  font-size: 1.25rem;
}

.grid-2 {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
}
.grid-3 {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1.5rem;
}

.flex { display: flex; }
.gap-2 { gap: 0.5rem; }
.mb-2 { margin-bottom: 0.5rem; }
.mb-0 { margin-bottom: 0; }
.mt-4 { margin-top: 1rem; }

.facility-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1rem;
}
.chip {
  background: var(--c-primary-light);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 99px;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.chip-delete {
  color: white;
  font-size: 1.25rem;
  line-height: 1;
  opacity: 0.8;
}
.chip-delete:hover { opacity: 1; }

.toggle-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}
.toggle-label {
  font-weight: 500;
}
.help-text {
  font-size: 0.75rem;
  color: var(--c-text-muted);
}

/* Toggle Switch CSS */
.switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 24px;
}
.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}
.slider {
  position: absolute;
  cursor: pointer;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: #cbd5e1;
  transition: .4s;
}
.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
}
input:checked + .slider {
  background-color: var(--c-primary);
}
input:focus + .slider {
  box-shadow: 0 0 1px var(--c-primary);
}
input:checked + .slider:before {
  transform: translateX(24px);
}
.slider.round {
  border-radius: 24px;
}
.slider.round:before {
  border-radius: 50%;
}

.action-panel {
  position: sticky;
  top: 2rem;
}
.btn-block {
  width: 100%;
}
.btn-lg {
  padding: 1rem;
  font-size: 1.125rem;
}
</style>
