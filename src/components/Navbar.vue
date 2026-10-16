<template>
  <nav class="navbar" :class="{ 'scrolled': isScrolled }">
    <div class="container navbar-container">
      <router-link to="/" class="brand">
        <span class="brand-text">Griya Borneo.</span>
      </router-link>

      <!-- Desktop Menu -->
      <div class="nav-links desktop-only">
        <router-link to="/" class="nav-link" active-class="active">Katalog</router-link>
        <router-link to="/about" class="nav-link" active-class="active">Tentang Kami</router-link>
        <router-link to="/contact" class="nav-link" active-class="active">Kontak</router-link>
      </div>

      <!-- Mobile Toggle -->
      <button class="mobile-toggle" @click="isMobileOpen = !isMobileOpen">
        <MenuIcon v-if="!isMobileOpen" />
        <XIcon v-else />
      </button>
    </div>

    <!-- Mobile Menu -->
    <div class="mobile-menu" v-show="isMobileOpen">
      <router-link to="/" class="nav-link" active-class="active" @click="isMobileOpen = false">Katalog</router-link>
      <router-link to="/about" class="nav-link" active-class="active" @click="isMobileOpen = false">Tentang Kami</router-link>
      <router-link to="/contact" class="nav-link" active-class="active" @click="isMobileOpen = false">Kontak</router-link>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Menu as MenuIcon, X as XIcon } from 'lucide-vue-next'

const isScrolled = ref(false)
const isMobileOpen = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  transition: all 0.3s ease;
  padding: 1.5rem 0;
  background: transparent;
}
.navbar.scrolled {
  background: rgba(255, 255, 255, 0.95);
  padding: 1rem 0;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.brand {
  display: flex;
  align-items: center;
  text-decoration: none;
}
.brand-text {
  font-family: var(--font-heading);
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--c-primary-dark);
  letter-spacing: -0.5px;
}

.nav-links {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.nav-link {
  color: var(--c-text-muted);
  font-weight: 500;
  font-size: 0.95rem;
  transition: color 0.2s;
  position: relative;
}
.nav-link:hover, .nav-link.active {
  color: var(--c-primary-dark);
}
.nav-link.active::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: var(--c-primary);
  border-radius: 2px;
}

.desktop-only {
  display: flex;
}
.mobile-toggle {
  display: none;
  color: var(--c-text-main);
}

.mobile-menu {
  display: none;
  background: white;
  padding: 1rem 2rem;
  box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
}
.mobile-menu .nav-link {
  display: block;
  padding: 1rem 0;
  border-bottom: 1px solid var(--c-border);
}
.mobile-menu .nav-link:last-child {
  border-bottom: none;
}
.mobile-menu .nav-link.active::after {
  display: none; /* simpler active state on mobile */
}

@media (max-width: 768px) {
  .desktop-only { display: none; }
  .mobile-toggle { display: block; }
  .mobile-menu { display: block; }
  .navbar {
    background: white;
  }
}
</style>
