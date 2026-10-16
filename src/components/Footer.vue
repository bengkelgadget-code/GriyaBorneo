<template>
  <footer class="footer">
    <div class="container footer-content">
      <div class="footer-brand">
        <h2 class="footer-logo">Griya Borneo Property</h2>
        <p class="footer-desc">
          Mitra terpercaya Anda dalam mewujudkan hunian impian dan investasi properti terbaik di Kalimantan.
        </p>
      </div>
      
      <div class="footer-links">
        <h4 class="footer-title">Tautan Cepat</h4>
        <ul>
          <li><a href="#katalog">Katalog Properti</a></li>
          <li><a href="#tentang">Tentang Kami</a></li>
          <li><router-link to="/kelola-griya/login">Login Admin</router-link></li>
        </ul>
      </div>
      
      <div class="footer-contact">
        <h4 class="footer-title">Hubungi Kami</h4>
        <p>Jl. Jend. Sudirman No.123, Balikpapan</p>
        <p>Email: info@griyaborneo.com</p>
      </div>
    </div>
    
    <div class="footer-bottom">
      <div class="container">
        <p>&copy; {{ new Date().getFullYear() }} Griya Borneo Property. All rights reserved.</p>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background-color: var(--c-text-main);
  color: rgba(255, 255, 255, 0.8);
  padding-top: 4rem;
  border-top: 4px solid var(--c-accent);
}

.footer-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 3rem;
  margin-bottom: 3rem;
}

@media (min-width: 768px) {
  .footer-content {
    grid-template-columns: 2fr 1fr 1fr;
  }
}

.footer-logo {
  font-family: var(--font-heading);
  color: white;
  font-size: 1.75rem;
  margin-bottom: 1rem;
}

.footer-desc {
  max-width: 400px;
}

.footer-title {
  color: white;
  margin-bottom: 1.5rem;
  font-size: 1.125rem;
}

.footer-links ul {
  list-style: none;
}
.footer-links li {
  margin-bottom: 0.75rem;
}
.footer-links a {
  transition: color 0.2s;
}
.footer-links a:hover {
  color: var(--c-accent);
}

.footer-contact p {
  margin-bottom: 0.75rem;
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 1.5rem 0;
  text-align: center;
  font-size: 0.875rem;
}
</style>
