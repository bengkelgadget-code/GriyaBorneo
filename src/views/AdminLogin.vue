<template>
  <div class="login-page">
    <div class="login-card glass">
      <div class="text-center mb-6">
        <h2 class="login-title">Admin Login</h2>
        <p class="text-muted">Griya Borneo Property CMS</p>
      </div>
      
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label class="form-label">Nomor HP / WhatsApp Admin</label>
          <input 
            type="text" 
            v-model="phone" 
            class="form-control" 
            required 
            placeholder="Contoh: 08123456789"
          />
        </div>
        
        <div class="form-group">
          <label class="form-label">Password</label>
          <input 
            type="password" 
            v-model="password" 
            class="form-control" 
            required 
            placeholder="••••••••"
          />
        </div>
        
        <div v-if="errorMsg" class="error-msg">
          {{ errorMsg }}
        </div>
        
        <button type="submit" class="btn btn-primary w-full mt-4" :disabled="loading">
          <span v-if="loading">Memproses...</span>
          <span v-else>Login</span>
        </button>
      </form>
      
      <div class="text-center mt-6">
        <router-link to="/" class="text-sm text-primary hover-underline">
          &larr; Kembali ke Beranda
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

const phone = ref('')
const password = ref('')
const loading = ref(false)
const errorMsg = ref('')

const handleLogin = async () => {
  loading.value = true
  errorMsg.value = ''
  
  try {
    await authStore.login(phone.value, password.value)
    router.push('/kelola-griya')
  } catch (error) {
    errorMsg.value = error.message || 'Gagal login. Periksa kembali email & password Anda.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--c-primary-dark);
  background-image: linear-gradient(rgba(2, 44, 34, 0.8), rgba(2, 44, 34, 0.9)), url('https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80');
  background-size: cover;
  background-position: center;
  padding: 1rem;
}

.login-card {
  width: 100%;
  max-width: 400px;
  padding: 2.5rem;
  border-radius: var(--radius-lg);
  background: rgba(255, 255, 255, 0.95);
  box-shadow: var(--shadow-hover);
}

.login-title {
  font-size: 2rem;
  color: var(--c-primary-dark);
  margin-bottom: 0.5rem;
}

.text-center { text-align: center; }
.mb-6 { margin-bottom: 1.5rem; }
.mt-4 { margin-top: 1rem; }
.mt-6 { margin-top: 1.5rem; }
.text-muted { color: var(--c-text-muted); }
.w-full { width: 100%; }
.text-sm { font-size: 0.875rem; }
.text-primary { color: var(--c-primary); }
.hover-underline:hover { text-decoration: underline; }

.error-msg {
  background-color: rgba(239, 68, 68, 0.1);
  color: var(--c-danger);
  padding: 0.75rem;
  border-radius: var(--radius-sm);
  font-size: 0.875rem;
  margin-bottom: 1rem;
  border: 1px solid rgba(239, 68, 68, 0.2);
}
</style>
