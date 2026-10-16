<template>
  <div class="page-wrapper">
    <Navbar />
    
    <main class="content-container">
      <div class="contact-header">
        <h1 class="page-title">Mari Berbicara.</h1>
        <p class="subtitle">Tim kami siap membantu Anda menemukan properti yang sempurna.</p>
      </div>
      
      <div class="contact-grid">
        <div class="contact-card">
          <div class="icon-wrap">
            <MapPinIcon size="32" />
          </div>
          <h3>Kantor Pusat</h3>
          <p>Jl. Jend. Sudirman No. 123<br/>Balikpapan, Kalimantan Timur<br/>Indonesia 76114</p>
        </div>
        
        <div class="contact-card">
          <div class="icon-wrap">
            <PhoneIcon size="32" />
          </div>
          <h3>Telepon</h3>
          <p>
            <a href="tel:+6281234567890">+62 812-3456-7890</a><br/>
            Senin - Jumat, 08:00 - 17:00
          </p>
        </div>
        
        <div class="contact-card">
          <div class="icon-wrap">
            <MailIcon size="32" />
          </div>
          <h3>Email</h3>
          <p>
            <a href="mailto:info@griyaborneo.com">info@griyaborneo.com</a><br/>
            <a href="mailto:sales@griyaborneo.com">sales@griyaborneo.com</a>
          </p>
        </div>
      </div>
    </main>
    
    <Footer />
  </div>
</template>

<script setup>
import Navbar from '@/components/Navbar.vue'
import Footer from '@/components/Footer.vue'
import { MapPin as MapPinIcon, Phone as PhoneIcon, Mail as MailIcon } from 'lucide-vue-next'
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
  max-width: 1200px;
  margin: 0 auto;
  padding: 120px 2rem 6rem;
}

.contact-header {
  text-align: center;
  margin-bottom: 6rem;
}
.page-title {
  font-size: clamp(3rem, 5vw, 4.5rem);
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}
.subtitle {
  font-size: 1.25rem;
  color: var(--c-text-muted);
}

.contact-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 3rem;
}

.contact-card {
  text-align: center;
  padding: 3rem 2rem;
  background: white;
  border-radius: var(--radius-lg);
  border: 1px solid var(--c-border);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.contact-card:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-lg);
}

.icon-wrap {
  width: 80px;
  height: 80px;
  margin: 0 auto 2rem;
  background: var(--c-surface-alt);
  color: var(--c-primary);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.contact-card h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}
.contact-card p {
  color: var(--c-text-muted);
  line-height: 1.8;
}
.contact-card a {
  color: var(--c-primary);
  font-weight: 500;
  transition: color 0.2s;
}
.contact-card a:hover {
  color: var(--c-primary-dark);
  text-decoration: underline;
}
</style>
