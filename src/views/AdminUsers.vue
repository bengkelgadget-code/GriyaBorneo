<template>
  <div class="users-page">
    <div class="page-header">
      <h1 class="page-title">Manajemen User</h1>
      <p class="text-muted">Kelola akun akses admin ke sistem CMS Griya Borneo.</p>
    </div>
    
    <div class="card info-card">
      <div class="info-icon">
        <InfoIcon size="24" />
      </div>
      <div class="info-content">
        <h3>Informasi Keamanan</h3>
        <p>
          Untuk alasan keamanan yang ketat, manajemen penambahan dan penghapusan user admin 
          hanya dapat dilakukan langsung melalui <strong>Supabase Dashboard</strong>. 
          Sistem saat ini tidak mengizinkan registrasi admin secara publik.
        </p>
        <a href="https://app.supabase.com" target="_blank" class="btn btn-outline mt-4 inline-flex">
          Buka Supabase Dashboard
        </a>
      </div>
    </div>
    
    <h3 class="mt-8 mb-4">Akun Anda Saat Ini</h3>
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>Email</th>
            <th>ID Pengguna</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="user">
            <td class="font-semibold">{{ user.email }}</td>
            <td class="text-muted font-mono text-sm">{{ user.id }}</td>
            <td><span class="badge badge-success">Aktif / Login</span></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '@/stores/authStore'
import { Info as InfoIcon } from 'lucide-vue-next'

const authStore = useAuthStore()
const user = computed(() => authStore.user)
</script>

<style scoped>
.page-header {
  margin-bottom: 2rem;
}
.page-title {
  font-size: 2rem;
  margin-bottom: 0.25rem;
}

.info-card {
  background: rgba(59, 130, 246, 0.05);
  border: 1px solid rgba(59, 130, 246, 0.2);
  display: flex;
  gap: 1.5rem;
}
.info-icon {
  color: #3b82f6;
  padding-top: 0.25rem;
}
.info-content h3 {
  color: #1e3a8a;
  margin-bottom: 0.5rem;
}
.info-content p {
  line-height: 1.6;
  color: var(--c-text-main);
}

.card {
  padding: 2rem;
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
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

.badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: var(--radius-sm);
  font-size: 0.75rem;
  font-weight: 600;
}
.badge-success { background: rgba(16, 185, 129, 0.1); color: var(--c-success); }

/* Utilities */
.text-muted { color: var(--c-text-muted); }
.mt-4 { margin-top: 1rem; }
.mt-8 { margin-top: 2rem; }
.mb-4 { margin-bottom: 1rem; }
.inline-flex { display: inline-flex; align-items: center; }
.font-semibold { font-weight: 600; }
.font-mono { font-family: monospace; }
.text-sm { font-size: 0.875rem; }
</style>
