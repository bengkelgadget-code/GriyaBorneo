<template>
  <section class="stats-section">
    <div class="container stats-container">
      <div class="stat-item">
        <h3 class="stat-number">150+</h3>
        <p class="stat-label">Unit Terjual</p>
      </div>
      <div class="stat-item">
        <h3 class="stat-number">10+</h3>
        <p class="stat-label">Cluster Eksklusif</p>
      </div>
      <div class="stat-item">
        <h3 class="stat-number">5+</h3>
        <p class="stat-label">Tahun Pengalaman</p>
      </div>
      <div class="stat-item">
        <h3 class="stat-number">100%</h3>
        <p class="stat-label">Legalitas Aman</p>
      </div>
    </div>
  </section>
</template>

<style scoped>
.stats-section {
  background-color: var(--c-primary);
  color: white;
  padding: 4rem 0;
}

.stats-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
  text-align: center;
}

@media (min-width: 768px) {
  .stats-container {
    grid-template-columns: repeat(4, 1fr);
  }
}

.stat-number {
  font-family: var(--font-heading);
  font-size: 3rem;
  color: var(--c-accent-light);
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1.125rem;
  font-weight: 500;
  opacity: 0.9;
}
</style>
