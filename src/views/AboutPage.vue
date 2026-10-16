<template>
  <div class="page-wrapper">
    <Navbar />
    
    <main class="content-container">
      <div class="about-hero">
        <h1 class="page-title">Membangun Hunian <br/>Membangun Masa Depan.</h1>
        <p class="subtitle">Griya Borneo Property hadir untuk memberikan solusi hunian terbaik yang memadukan kenyamanan, estetika, dan nilai investasi jangka panjang.</p>
      </div>
      
      <div class="about-content">
        <div class="text-block">
          <h2>Visi Kami</h2>
          <p>Menjadi pengembang properti terdepan di Kalimantan yang dikenal atas integritas, inovasi desain, dan komitmen terhadap kepuasan pelanggan.</p>
        </div>
        
        <div class="text-block">
          <h2>Misi Kami</h2>
          <p>Menciptakan lingkungan tempat tinggal yang asri dan berkelanjutan. Memberikan pelayanan yang transparan dan profesional. Mewujudkan mimpi setiap keluarga untuk memiliki rumah yang layak dan berkualitas tinggi.</p>
        </div>
      </div>
    </main>
    
    <Footer />
  </div>
</template>

<script setup>
import Navbar from '@/components/Navbar.vue'
import Footer from '@/components/Footer.vue'
</script>

<style scoped>
.page-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.content-container {
  flex: 1;
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  padding: 120px 2rem 6rem; /* space for navbar */
}

.about-hero {
  margin-bottom: 5rem;
}
.page-title {
  font-size: clamp(3rem, 5vw, 4.5rem);
  line-height: 1.1;
  margin-bottom: 2rem;
  color: var(--c-text-main);
  letter-spacing: -0.02em;
}
.subtitle {
  font-size: 1.25rem;
  color: var(--c-text-muted);
  max-width: 600px;
  line-height: 1.8;
}

.about-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 4rem;
}
@media (min-width: 768px) {
  .about-content {
    grid-template-columns: 1fr 1fr;
  }
}

.text-block h2 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  position: relative;
  display: inline-block;
}
.text-block h2::after {
  content: '';
  position: absolute;
  bottom: -0.5rem;
  left: 0;
  width: 40px;
  height: 2px;
  background-color: var(--c-primary);
}
.text-block p {
  color: var(--c-text-muted);
  font-size: 1.1rem;
  line-height: 1.8;
}
</style>
