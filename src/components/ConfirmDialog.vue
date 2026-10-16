<template>
  <div v-if="show" class="modal-overlay">
    <div class="modal-content glass">
      <h3 class="modal-title">{{ title }}</h3>
      <p class="modal-message">{{ message }}</p>
      <div class="modal-actions">
        <button class="btn btn-outline" @click="cancel">Batal</button>
        <button class="btn" :class="confirmBtnClass" @click="confirm">{{ confirmText }}</button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: Boolean,
  title: {
    type: String,
    default: 'Konfirmasi'
  },
  message: {
    type: String,
    default: 'Apakah Anda yakin ingin melanjutkan?'
  },
  confirmText: {
    type: String,
    default: 'Ya, Lanjutkan'
  },
  confirmBtnClass: {
    type: String,
    default: 'btn-primary' // e.g. btn-danger for delete
  }
})

const emit = defineEmits(['confirm', 'cancel'])

const confirm = () => emit('confirm')
const cancel = () => emit('cancel')
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background: white;
  padding: 2rem;
  border-radius: var(--radius);
  width: 100%;
  max-width: 400px;
  box-shadow: var(--shadow-lg);
}

.modal-title {
  margin-bottom: 1rem;
  color: var(--c-text-main);
}

.modal-message {
  margin-bottom: 2rem;
  color: var(--c-text-muted);
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}
.btn-danger {
  background-color: var(--c-danger);
  color: white;
}
.btn-danger:hover {
  background-color: #dc2626;
}
</style>
