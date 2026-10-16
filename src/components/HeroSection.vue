<template>
  <section class="hero">
    <div class="hero-overlay"></div>
    <div class="container hero-content">
      <h1 class="hero-title">Temukan Hunian Mewah Impian Anda di Borneo</h1>
      <p class="hero-subtitle">Eksklusivitas, Kenyamanan, dan Investasi Terbaik Masa Depan</p>
      
      <div class="hero-actions">
        <a href="#katalog" class="btn btn-primary btn-large">Lihat Katalog Properti</a>
      </div>
    </div>
  </section>
</template>

<style scoped>
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  background-color: var(--c-primary-dark);
  /* You can add a background image url() here later */
  background-image: linear-gradient(rgba(2, 44, 34, 0.7), rgba(2, 44, 34, 0.9)), url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80');
  background-size: cover;
  background-position: center;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, transparent, var(--c-bg));
  opacity: 0.8;
}

.hero-content {
  position: relative;
  z-index: 10;
  text-align: center;
  max-width: 800px;
  margin: 0 auto;
  padding-top: 5rem;
}

.hero-title {
  font-size: 3.5rem;
  color: white;
  margin-bottom: 1.5rem;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 2.5rem;
}

.btn-large {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }
}
</style>
