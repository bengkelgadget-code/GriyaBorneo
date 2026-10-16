<template>
  <aside class="admin-sidebar" :class="{ 'sidebar-open': isOpen }">
    <div class="sidebar-header">
      <h2 class="sidebar-logo">Admin CMS</h2>
      <button class="mobile-close" @click="isOpen = false">
        <XIcon />
      </button>
    </div>
    
    <nav class="sidebar-nav">
      <router-link to="/kelola-griya" class="nav-item" exact-active-class="active" @click="closeMobile">
        <LayoutDashboardIcon size="20" /> Dashboard
      </router-link>
      <router-link to="/kelola-griya/live-chat" class="nav-item" active-class="active" @click="closeMobile">
        <MessageSquareIcon size="20" /> Live Chat & CRM
      </router-link>
      <router-link to="/kelola-griya/property/new" class="nav-item" active-class="active" @click="closeMobile">
        <PlusSquareIcon size="20" /> Tambah Properti
      </router-link>
      <router-link to="/kelola-griya/settings" class="nav-item" active-class="active" @click="closeMobile">
        <SettingsIcon size="20" /> Pengaturan
      </router-link>
      <router-link to="/kelola-griya/users" class="nav-item" active-class="active" @click="closeMobile">
        <UsersIcon size="20" /> Kelola User
      </router-link>
    </nav>
    
    <div class="sidebar-footer">
      <div class="user-info" v-if="user">
        <span class="user-email">{{ formatUserDisplay(user.email) }}</span>
      </div>
      <button @click="handleLogout" class="btn-logout">
        <LogOutIcon size="18" /> Logout
      </button>
    </div>
  </aside>
  
  <!-- Mobile toggle button (visible only on mobile) -->
  <button class="mobile-toggle-btn" @click="isOpen = true" v-if="!isOpen">
    <MenuIcon />
  </button>
  
  <!-- Overlay for mobile -->
  <div class="sidebar-overlay" v-if="isOpen" @click="isOpen = false"></div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/authStore'
import { 
  LayoutDashboard as LayoutDashboardIcon, 
  MessageSquare as MessageSquareIcon,
  PlusSquare as PlusSquareIcon, 
  Settings as SettingsIcon,
  Users as UsersIcon,
  LogOut as LogOutIcon,
  Menu as MenuIcon,
  X as XIcon
} from 'lucide-vue-next'

const router = useRouter()
const authStore = useAuthStore()

const isOpen = ref(false)
const user = computed(() => authStore.user)

const formatUserDisplay = (email) => {
  if (!email) return ''
  if (email.endsWith('@griyaborneo.id')) {
    return email.replace('@griyaborneo.id', '')
  }
  return email
}

const closeMobile = () => {
  if (window.innerWidth <= 768) {
    isOpen.value = false
  }
}

const handleLogout = async () => {
  try {
    await authStore.logout()
    router.push('/kelola-griya/login')
  } catch (error) {
    console.error('Logout error:', error)
  }
}
</script>

<style scoped>
.sidebar-header {
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}
.sidebar-logo {
  font-family: var(--font-heading);
  color: var(--c-accent-light);
  font-size: 1.5rem;
}

.mobile-close {
  display: none;
  color: white;
}

.sidebar-nav {
  padding: 1.5rem 0;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.5rem;
  color: rgba(255, 255, 255, 0.7);
  transition: all 0.2s;
}
.nav-item:hover, .nav-item.active {
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
  border-left: 4px solid var(--c-accent);
}

.sidebar-footer {
  padding: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  margin-top: auto;
}
.user-info {
  margin-bottom: 1rem;
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
  overflow: hidden;
  text-overflow: ellipsis;
}
.btn-logout {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  width: 100%;
  padding: 0.75rem;
  color: white;
  background-color: rgba(239, 68, 68, 0.2);
  border-radius: var(--radius-sm);
  transition: background-color 0.2s;
}
.btn-logout:hover {
  background-color: rgba(239, 68, 68, 0.4);
}

.mobile-toggle-btn {
  display: none;
  position: fixed;
  bottom: 1.5rem;
  right: 1.5rem;
  z-index: 40;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background-color: var(--c-primary);
  color: white;
  box-shadow: var(--shadow-lg);
}

.sidebar-overlay {
  display: none;
}

@media (max-width: 768px) {
  .admin-sidebar {
    position: fixed;
    top: 0;
    left: -100%;
    height: 100vh;
    z-index: 50;
    transition: left 0.3s ease;
    display: flex;
    flex-direction: column;
  }
  .admin-sidebar.sidebar-open {
    left: 0;
  }
  .mobile-close, .mobile-toggle-btn {
    display: block;
  }
  .mobile-toggle-btn {
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .sidebar-overlay {
    display: block;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.5);
    z-index: 45;
  }
}
</style>
