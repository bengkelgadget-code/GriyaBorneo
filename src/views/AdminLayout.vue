<template>
  <div class="admin-layout">
    <AdminSidebar />
    <main class="admin-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import AdminSidebar from '@/components/AdminSidebar.vue'
</script>
