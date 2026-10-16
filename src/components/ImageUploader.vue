<template>
  <div class="image-uploader">
    <div 
      class="upload-dropzone" 
      @dragover.prevent="isDragging = true"
      @dragleave.prevent="isDragging = false"
      @drop.prevent="handleDrop"
      :class="{ 'dragging': isDragging }"
    >
      <UploadCloudIcon size="48" class="text-muted mb-2" />
      <p class="mb-2">Tarik & lepas gambar ke sini atau</p>
      <label class="btn btn-primary btn-sm cursor-pointer">
        Pilih File
        <input 
          type="file" 
          multiple 
          accept="image/*" 
          class="hidden-input" 
          @change="handleFileInput"
        />
      </label>
      <p class="text-xs text-muted mt-2">Format: JPG, PNG, WEBP (Max 5MB)</p>
    </div>

    <div v-if="uploading" class="upload-progress">
      <div class="spinner"></div>
      <p>Mengunggah gambar...</p>
    </div>

    <!-- Preview Existing / Uploaded Images -->
    <div class="image-preview-grid" v-if="modelValue && modelValue.length > 0">
      <div v-for="(img, idx) in modelValue" :key="idx" class="preview-item">
        <img :src="img" alt="Preview" />
        <button class="btn-delete" @click.prevent="removeImage(idx)" title="Hapus Gambar">
          <Trash2Icon size="16" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { UploadCloud as UploadCloudIcon, Trash2 as Trash2Icon } from 'lucide-vue-next'

const props = defineProps({
  modelValue: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:modelValue'])

const isDragging = ref(false)
const uploading = ref(false)

const handleDrop = (e) => {
  isDragging.value = false
  const files = e.dataTransfer.files
  uploadFiles(files)
}

const handleFileInput = (e) => {
  const files = e.target.files
  uploadFiles(files)
}

const uploadFiles = async (files) => {
  if (!files || files.length === 0) return
  
  uploading.value = true
  const newUrls = [...props.modelValue]
  
  try {
    for (const file of Array.from(files)) {
      if (!file.type.startsWith('image/')) continue
      
      const fileExt = file.name.split('.').pop()
      const fileName = `${Math.random().toString(36).substring(2, 15)}_${Date.now()}.${fileExt}`
      const filePath = `properties/${fileName}`
      
      const { error: uploadError } = await supabase.storage
        .from('property-images')
        .upload(filePath, file)
        
      if (uploadError) {
        console.error('Error uploading image:', uploadError)
        continue
      }
      
      const { data } = supabase.storage
        .from('property-images')
        .getPublicUrl(filePath)
        
      if (data && data.publicUrl) {
        newUrls.push(data.publicUrl)
      }
    }
    
    emit('update:modelValue', newUrls)
  } catch (err) {
    console.error('Upload error:', err)
    alert('Terjadi kesalahan saat mengunggah gambar.')
  } finally {
    uploading.value = false
  }
}

const removeImage = async (index) => {
  // We can optionally delete it from Supabase storage here too
  // For simplicity, we just remove from the array right now.
  const newUrls = [...props.modelValue]
  newUrls.splice(index, 1)
  emit('update:modelValue', newUrls)
}
</script>

<style scoped>
.upload-dropzone {
  border: 2px dashed var(--c-border);
  border-radius: var(--radius);
  padding: 3rem 1.5rem;
  text-align: center;
  transition: all 0.2s;
  background-color: var(--c-bg);
  margin-bottom: 1.5rem;
}
.upload-dropzone.dragging {
  border-color: var(--c-primary);
  background-color: rgba(16, 185, 129, 0.05);
}
.hidden-input {
  display: none;
}
.cursor-pointer {
  cursor: pointer;
}
.text-muted { color: var(--c-text-muted); }
.mb-2 { margin-bottom: 0.5rem; }
.mt-2 { margin-top: 0.5rem; }
.text-xs { font-size: 0.75rem; }

.upload-progress {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
  color: var(--c-primary);
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

.image-preview-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
}
.preview-item {
  position: relative;
  aspect-ratio: 1;
  border-radius: var(--radius-sm);
  overflow: hidden;
  border: 1px solid var(--c-border);
}
.preview-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.btn-delete {
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  background: rgba(239, 68, 68, 0.9);
  color: white;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s;
}
.btn-delete:hover {
  background: rgb(220, 38, 38);
}
</style>
