<template>
  <div class="settings-page">
    <div class="page-header">
      <h1 class="page-title">Pengaturan Sistem</h1>
      <p class="text-muted">Kelola pengaturan global untuk website Anda.</p>
    </div>
    
    <div v-if="loading" class="text-center p-8">
      <div class="spinner inline-block"></div>
    </div>
    
    <div v-else class="settings-container">
      <form @submit.prevent="saveSettings" class="card">
        <h3 class="card-title">Kontak & Integrasi</h3>
        
        <div class="form-group">
          <label class="form-label">Nomor WhatsApp Utama</label>
          <div class="input-with-icon">
            <span class="prefix">+62</span>
            <input 
              type="text" 
              v-model="waNumber" 
              class="form-control pl-prefix" 
              placeholder="81234567890" 
              required
            />
          </div>
          <p class="help-text mt-1">Nomor ini akan digunakan sebagai default untuk tombol floating WhatsApp dan CTA di detail properti.</p>
        </div>
        
        <button type="submit" class="btn btn-primary" :disabled="saving">
          {{ saving ? 'Menyimpan...' : 'Simpan Pengaturan' }}
        </button>
        
        <div v-if="successMsg" class="success-msg mt-4">
          {{ successMsg }}
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSettingStore } from '@/stores/settingStore'

const settingStore = useSettingStore()

const waNumber = ref('')
const loading = ref(true)
const saving = ref(false)
const successMsg = ref('')

onMounted(async () => {
  await settingStore.fetchSettings()
  let num = settingStore.settings['whatsapp_number'] || ''
  // Clean prefix if exists
  if (num.startsWith('62')) num = num.substring(2)
  if (num.startsWith('0')) num = num.substring(1)
  waNumber.value = num
  loading.value = false
})

const saveSettings = async () => {
  saving.value = true
  successMsg.value = ''
  
  try {
    let finalNumber = waNumber.value.replace(/\D/g, '')
    if (finalNumber.startsWith('0')) finalNumber = finalNumber.substring(1)
    finalNumber = '62' + finalNumber
    
    await settingStore.saveSetting('whatsapp_number', finalNumber, 'Nomor WhatsApp utama untuk kontak CTA')
    successMsg.value = 'Pengaturan berhasil disimpan!'
    
    setTimeout(() => { successMsg.value = '' }, 3000)
  } catch (error) {
    console.error(error)
    alert('Gagal menyimpan pengaturan')
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.page-header {
  margin-bottom: 2rem;
}
.page-title {
  font-size: 2rem;
  margin-bottom: 0.25rem;
}

.settings-container {
  max-width: 600px;
}

.card {
  background: white;
  padding: 2rem;
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--c-border);
}
.card-title {
  margin-bottom: 1.5rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid var(--c-border);
}

.input-with-icon {
  position: relative;
  display: flex;
  align-items: center;
}
.prefix {
  position: absolute;
  left: 1rem;
  color: var(--c-text-muted);
  font-weight: 500;
}
.pl-prefix {
  padding-left: 3.5rem;
}

.help-text {
  font-size: 0.75rem;
  color: var(--c-text-muted);
}
.mt-1 { margin-top: 0.25rem; }
.mt-4 { margin-top: 1rem; }
.text-muted { color: var(--c-text-muted); }

.success-msg {
  background-color: rgba(16, 185, 129, 0.1);
  color: var(--c-success);
  padding: 0.75rem;
  border-radius: var(--radius-sm);
  font-size: 0.875rem;
  border: 1px solid rgba(16, 185, 129, 0.2);
}

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
.text-center { text-align: center; }
.p-8 { padding: 2rem; }
.inline-block { display: inline-block; }
</style>
