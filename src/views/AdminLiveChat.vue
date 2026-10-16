<template>
  <div class="live-chat-crm">
    <!-- Top Header & Stats -->
    <div class="crm-header">
      <div>
        <h1 class="crm-title">Live Chat & Monitoring CRM</h1>
        <p class="crm-subtitle">Pantau obrolan Bot WhatsApp, riwayat chat konsumen, dan kelola janji survei unit secara realtime.</p>
      </div>

      <div class="header-badges">
        <div class="realtime-pill" :class="{ 'connected': isRealtimeConnected }">
          <span class="pulsing-dot"></span>
          <span>{{ isRealtimeConnected ? 'Realtime Terhubung' : 'Menghubungkan...' }}</span>
        </div>
      </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon bg-emerald">
          <UsersIcon size="20" />
        </div>
        <div>
          <span class="stat-num">{{ sessions.length }}</span>
          <span class="stat-label">Total Konsumen</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon bg-amber">
          <CalendarCheckIcon size="20" />
        </div>
        <div>
          <span class="stat-num">{{ surveyCount }}</span>
          <span class="stat-label">Ada Janji Survei</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon bg-blue">
          <SparklesIcon size="20" />
        </div>
        <div>
          <span class="stat-num">{{ dealCount }}</span>
          <span class="stat-label">Prospek Closing</span>
        </div>
      </div>
    </div>

    <!-- Main 3-Panel Layout -->
    <div class="crm-workspace">
      <!-- 1. LEFT PANEL: Contact List -->
      <aside class="panel-contacts" :class="{ 'mobile-hidden': activeTab !== 'contacts' && isMobile }">
        <div class="panel-header">
          <div class="search-box">
            <SearchIcon size="16" class="search-icon" />
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Cari nomor HP atau nama..." 
              class="search-input"
            />
          </div>

          <!-- Filter Pills -->
          <div class="filter-pills">
            <button 
              class="pill-btn" 
              :class="{ active: contactFilter === 'all' }" 
              @click="contactFilter = 'all'"
            >
              Semua ({{ sessions.length }})
            </button>
            <button 
              class="pill-btn" 
              :class="{ active: contactFilter === 'survey' }" 
              @click="contactFilter = 'survey'"
            >
              📅 Ada Janji ({{ surveyCount }})
            </button>
          </div>
        </div>

        <div class="contacts-list" v-if="filteredSessions.length > 0">
          <div 
            v-for="s in filteredSessions" 
            :key="s.sessionId"
            class="contact-card"
            :class="{ active: selectedSessionId === s.sessionId }"
            @click="selectSession(s.sessionId)"
          >
            <div class="contact-avatar">
              <UserIcon size="20" />
            </div>

            <div class="contact-info">
              <div class="contact-row">
                <span class="contact-name">{{ s.lead?.customer_name || 'Calon Pembeli' }}</span>
                <span class="contact-time">{{ formatTime(s.lastTime) }}</span>
              </div>

              <div class="contact-phone">{{ formatPhone(s.sessionId) }}</div>

              <div class="contact-preview">{{ s.lastMessage || 'Tidak ada pesan' }}</div>

              <!-- Badge Janji Survei -->
              <div v-if="s.lead?.survey_schedule" class="survey-badge">
                <CalendarIcon size="12" />
                <span>{{ s.lead.survey_schedule }}</span>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="empty-list">
          <MessageSquareIcon size="32" class="empty-icon" />
          <p>Tidak ada kontak ditemukan</p>
        </div>
      </aside>

      <!-- 2. MIDDLE PANEL: Live Chat Room -->
      <main class="panel-chat" :class="{ 'mobile-hidden': activeTab !== 'chat' && isMobile }">
        <template v-if="selectedSession">
          <!-- Chat Header -->
          <div class="chat-header">
            <button class="back-mobile-btn" @click="activeTab = 'contacts'" v-if="isMobile">
              <ChevronLeftIcon size="20" />
            </button>

            <div class="chat-user-avatar">
              <UserIcon size="22" />
            </div>

            <div class="chat-user-meta">
              <h3>{{ selectedLead?.customer_name || 'Calon Pembeli' }}</h3>
              <span class="chat-status">
                <span class="online-indicator"></span> 
                {{ formatPhone(selectedSessionId) }} • Ditangani Bot CS
              </span>
            </div>

            <div class="chat-header-actions">
              <a 
                :href="`https://wa.me/${selectedSessionId}`" 
                target="_blank" 
                class="action-btn-whatsapp"
                title="Buka Chat di WhatsApp"
              >
                <ExternalLinkIcon size="16" /> Chat WA
              </a>

              <a 
                :href="`tel:+${selectedSessionId}`" 
                class="action-btn-call"
                title="Telepon Langsung"
              >
                <PhoneCallIcon size="16" /> Telpon
              </a>

              <button class="detail-toggle-btn" @click="activeTab = 'details'" v-if="isMobile">
                <InfoIcon size="18" />
              </button>
            </div>
          </div>

          <!-- Messages Stream -->
          <div class="messages-container" ref="messagesContainer">
            <div v-if="loadingMessages" class="loading-state">
              <LoaderIcon size="24" class="spin" />
              <span>Memuat percakapan...</span>
            </div>

            <div v-else-if="messages.length === 0" class="empty-state">
              <p>Belum ada obrolan dengan nomor ini.</p>
            </div>

            <div v-else class="messages-stream">
              <div 
                v-for="(msg, index) in messages" 
                :key="msg.id || index"
                class="message-row"
                :class="msg.senderType === 'human' ? 'row-human' : 'row-ai'"
              >
                <div class="message-bubble" :class="msg.senderType === 'human' ? 'bubble-human' : 'bubble-ai'">
                  <div class="sender-label">
                    {{ msg.senderType === 'human' ? 'Konsumen' : '🤖 AI CS Griya Borneo' }}
                  </div>
                  <div class="message-text">{{ cleanMessage(msg.text) }}</div>
                  <div class="message-meta">{{ formatTimestamp(msg.createdAt) }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Live Notice Footer -->
          <div class="chat-footer-notice">
            <BotIcon size="16" />
            <span>Obrolan ini berjalan otomatis via AI Agent n8n. Setiap chat baru akan langsung muncul di sini.</span>
          </div>
        </template>

        <!-- No Selection Placeholder -->
        <div v-else class="no-selection">
          <MessageCircleIcon size="48" class="placeholder-icon" />
          <h3>Pilih Percakapan Konsumen</h3>
          <p>Klik salah satu kontak di bilah sebelah kiri untuk membaca percakapan live dan mengelola janji surveinya.</p>
        </div>
      </main>

      <!-- 3. RIGHT PANEL: Customer Lead & Survey Tracker -->
      <aside class="panel-details" :class="{ 'mobile-hidden': activeTab !== 'details' && isMobile }">
        <template v-if="selectedSession">
          <div class="details-header">
            <button class="back-mobile-btn" @click="activeTab = 'chat'" v-if="isMobile">
              <ChevronLeftIcon size="20" />
            </button>
            <h3>Detail Prospek & Janji</h3>
          </div>

          <div class="details-content">
            <!-- Profil Card -->
            <div class="detail-section">
              <label class="section-title">Profil Konsumen</label>
              
              <div class="form-group">
                <span class="field-label">Nama Pembeli</span>
                <input 
                  v-model="leadForm.customer_name" 
                  type="text" 
                  class="input-clean" 
                  placeholder="Misal: Kak Zainal"
                />
              </div>

              <div class="form-group">
                <span class="field-label">Nomor WhatsApp</span>
                <div class="readonly-field">{{ formatPhone(selectedSessionId) }}</div>
              </div>

              <div class="form-group">
                <span class="field-label">Minat Unit Properti</span>
                <input 
                  v-model="leadForm.unit_interest" 
                  type="text" 
                  class="input-clean" 
                  placeholder="Misal: Tipe 47 Jl. M. Said"
                />
              </div>
            </div>

            <!-- Survey Tracker Card -->
            <div class="detail-section highlight-card">
              <label class="section-title">
                <CalendarCheckIcon size="16" /> Jadwal Survei Lokasi
              </label>

              <div class="form-group">
                <span class="field-label">Jadwal dari Chat</span>
                <input 
                  v-model="leadForm.survey_schedule" 
                  type="text" 
                  class="input-clean" 
                  placeholder="Misal: Sabtu jam 10:00 WITA"
                />
              </div>

              <div class="form-group">
                <span class="field-label">Status Prospek</span>
                <select v-model="leadForm.survey_status" class="select-clean">
                  <option value="no_survey">⚪ Belum Ada Janji</option>
                  <option value="pending">⏳ Menunggu Survei</option>
                  <option value="confirmed">📌 Terkonfirmasi Siap Cek</option>
                  <option value="completed">✅ Sudah Cek Lokasi</option>
                  <option value="deal">🤝 Closing / Booking Unit</option>
                  <option value="canceled">❌ Batal</option>
                </select>
              </div>

              <div class="form-group">
                <span class="field-label">Catatan Tim Sales</span>
                <textarea 
                  v-model="leadForm.notes" 
                  class="textarea-clean" 
                  rows="3" 
                  placeholder="Catatan khusus, budget konsumen, atau hasil survei..."
                ></textarea>
              </div>

              <button class="btn-save-lead" :disabled="savingLead" @click="saveLead">
                <SaveIcon size="16" />
                <span>{{ savingLead ? 'Menyimpan...' : 'Simpan Perubahan' }}</span>
              </button>
            </div>
          </div>
        </template>

        <div v-else class="empty-details">
          <InfoIcon size="32" class="empty-icon" />
          <p>Detail prospek akan tampil saat kontak dipilih.</p>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { supabase } from '@/lib/supabase'
import { 
  Users as UsersIcon, 
  CalendarCheck as CalendarCheckIcon, 
  Sparkles as SparklesIcon,
  Search as SearchIcon,
  User as UserIcon,
  Calendar as CalendarIcon,
  MessageSquare as MessageSquareIcon,
  MessageCircle as MessageCircleIcon,
  ChevronLeft as ChevronLeftIcon,
  ExternalLink as ExternalLinkIcon,
  PhoneCall as PhoneCallIcon,
  Info as InfoIcon,
  Bot as BotIcon,
  Loader as LoaderIcon,
  Save as SaveIcon
} from 'lucide-vue-next'

// State
const sessions = ref([])
const leadsMap = ref({})
const selectedSessionId = ref(null)
const messages = ref([])
const loadingMessages = ref(false)
const searchQuery = ref('')
const contactFilter = ref('all') // 'all' | 'survey'
const isRealtimeConnected = ref(false)
const activeTab = ref('contacts') // 'contacts' | 'chat' | 'details' (for mobile)
const isMobile = ref(false)
const savingLead = ref(false)
const messagesContainer = ref(null)

const leadForm = ref({
  customer_name: '',
  unit_interest: '',
  survey_schedule: '',
  survey_status: 'pending',
  notes: ''
})

let realtimeChannel = null

// Responsive check
const checkMobile = () => {
  isMobile.value = window.innerWidth <= 900
}

// Computed
const surveyCount = computed(() => {
  return Object.values(leadsMap.value).filter(l => l.survey_schedule && l.survey_status !== 'no_survey').length
})

const dealCount = computed(() => {
  return Object.values(leadsMap.value).filter(l => l.survey_status === 'deal').length
})

const selectedSession = computed(() => {
  return sessions.value.find(s => s.sessionId === selectedSessionId.value)
})

const selectedLead = computed(() => {
  return leadsMap.value[selectedSessionId.value]
})

const filteredSessions = computed(() => {
  return sessions.value.filter(s => {
    const lead = leadsMap.value[s.sessionId] || {}
    const name = (lead.customer_name || '').toLowerCase()
    const phone = s.sessionId.toLowerCase()
    const query = searchQuery.value.toLowerCase().trim()

    const matchesSearch = name.includes(query) || phone.includes(query)

    if (contactFilter.value === 'survey') {
      const hasSurvey = lead.survey_schedule && lead.survey_status !== 'no_survey'
      return matchesSearch && hasSurvey
    }

    return matchesSearch
  })
})

// Formatting Helpers
const formatPhone = (phone) => {
  if (!phone) return ''
  let cleaned = String(phone).replace(/\D/g, '')
  if (cleaned.startsWith('62')) {
    return '0' + cleaned.slice(2).replace(/(\d{3,4})(\d{4})(\d{3,4})/, '$1-$2-$3')
  }
  return cleaned
}

const formatTime = (isoString) => {
  if (!isoString) return ''
  const date = new Date(isoString)
  if (isNaN(date.getTime())) return ''
  return date.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
}

const formatTimestamp = (isoString) => {
  if (!isoString) return ''
  const date = new Date(isoString)
  if (isNaN(date.getTime())) return ''
  return date.toLocaleString('id-ID', { 
    day: 'numeric', 
    month: 'short', 
    hour: '2-digit', 
    minute: '2-digit' 
  })
}

const cleanMessage = (content) => {
  if (!content) return ''
  return String(content)
    .replace(/#REPORT_SURVEY[\s\S]*/gi, '')
    .replace(/FOTO:\s*.+/gi, '')
    .trim()
}

// Fetch Leads & Sessions
const fetchLeads = async () => {
  const { data, error } = await supabase
    .from('customer_leads')
    .select('*')
  
  if (!error && data) {
    const map = {}
    data.forEach(lead => {
      map[lead.phone_number] = lead
    })
    leadsMap.value = map
  }
}

const fetchSessions = async () => {
  try {
    const { data, error } = await supabase
      .from('n8n_chat_histories')
      .select('id, session_id, message')
      .order('id', { ascending: false })

    if (error) {
      console.error('Error fetching chat histories:', error)
      return
    }

    const sessionAgg = {}
    data.forEach(row => {
      const sid = row.session_id
      if (!sid) return

      let parsedMsg = row.message
      if (typeof parsedMsg === 'string') {
        try { parsedMsg = JSON.parse(parsedMsg) } catch (e) {}
      }

      const text = parsedMsg?.content || ''
      const time = parsedMsg?.additional_kwargs?.timestamp || new Date().toISOString()

      if (!sessionAgg[sid]) {
        sessionAgg[sid] = {
          sessionId: sid,
          lastMessage: text,
          lastTime: time,
          lead: leadsMap.value[sid] || null
        }
      }
    })

    sessions.value = Object.values(sessionAgg)

    // Select first session by default if not set
    if (!selectedSessionId.value && sessions.value.length > 0) {
      selectSession(sessions.value[0].sessionId)
    }
  } catch (err) {
    console.error('Error parsing sessions:', err)
  }
}

// Select a session and load chat messages
const selectSession = async (sessionId) => {
  selectedSessionId.value = sessionId
  activeTab.value = 'chat'
  loadingMessages.value = true

  // Fill form
  const lead = leadsMap.value[sessionId] || {}
  leadForm.value = {
    customer_name: lead.customer_name || 'Calon Pembeli',
    unit_interest: lead.unit_interest || '',
    survey_schedule: lead.survey_schedule || '',
    survey_status: lead.survey_status || 'no_survey',
    notes: lead.notes || ''
  }

  try {
    const { data, error } = await supabase
      .from('n8n_chat_histories')
      .select('id, message')
      .eq('session_id', sessionId)
      .order('id', { ascending: true })

    if (!error && data) {
      messages.value = data.map(item => {
        let msg = item.message
        if (typeof msg === 'string') {
          try { msg = JSON.parse(msg) } catch (e) {}
        }
        return {
          id: item.id,
          senderType: msg?.type === 'human' ? 'human' : 'ai',
          text: msg?.content || '',
          createdAt: msg?.additional_kwargs?.timestamp || new Date().toISOString()
        }
      })
    }
  } catch (err) {
    console.error('Fetch messages error:', err)
  } finally {
    loadingMessages.value = false
    scrollToBottom()
  }
}

// Save Lead changes
const saveLead = async () => {
  if (!selectedSessionId.value) return
  savingLead.value = true

  try {
    const payload = {
      phone_number: selectedSessionId.value,
      customer_name: leadForm.value.customer_name,
      unit_interest: leadForm.value.unit_interest,
      survey_schedule: leadForm.value.survey_schedule,
      survey_status: leadForm.value.survey_status,
      notes: leadForm.value.notes,
      updated_at: new Date().toISOString()
    }

    const { data, error } = await supabase
      .from('customer_leads')
      .upsert(payload, { onConflict: 'phone_number' })
      .select()

    if (!error && data && data.length > 0) {
      leadsMap.value[selectedSessionId.value] = data[0]
      // Update session reference
      const s = sessions.value.find(item => item.sessionId === selectedSessionId.value)
      if (s) s.lead = data[0]
    }
  } catch (err) {
    console.error('Save lead error:', err)
  } finally {
    savingLead.value = false
  }
}

// Scroll to bottom
const scrollToBottom = (delay = 50) => {
  nextTick(() => {
    setTimeout(() => {
      if (messagesContainer.value) {
        messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
      }
    }, delay)
  })
}

// Setup Realtime Supabase Channel
const setupRealtime = () => {
  realtimeChannel = supabase
    .channel('crm-live-chat')
    .on(
      'postgres_changes',
      { event: 'INSERT', schema: 'public', table: 'n8n_chat_histories' },
      (payload) => {
        const newRow = payload.new
        if (!newRow) return

        let msg = newRow.message
        if (typeof msg === 'string') {
          try { msg = JSON.parse(msg) } catch (e) {}
        }

        const sid = newRow.session_id
        const text = msg?.content || ''

        // Update session list
        const existingSession = sessions.value.find(s => s.sessionId === sid)
        if (existingSession) {
          existingSession.lastMessage = text
          existingSession.lastTime = new Date().toISOString()
          // Move to top
          sessions.value = [existingSession, ...sessions.value.filter(s => s.sessionId !== sid)]
        } else {
          sessions.value.unshift({
            sessionId: sid,
            lastMessage: text,
            lastTime: new Date().toISOString(),
            lead: leadsMap.value[sid] || null
          })
        }

        // If currently open session
        if (sid === selectedSessionId.value) {
          messages.value.push({
            id: newRow.id,
            senderType: msg?.type === 'human' ? 'human' : 'ai',
            text: text,
            createdAt: new Date().toISOString()
          })
          scrollToBottom()
        }

        // Check if report survey
        if (text.includes('#REPORT_SURVEY')) {
          fetchLeads()
        }
      }
    )
    .on(
      'postgres_changes',
      { event: '*', schema: 'public', table: 'customer_leads' },
      (payload) => {
        if (payload.new && payload.new.phone_number) {
          leadsMap.value[payload.new.phone_number] = payload.new
        }
      }
    )
    .subscribe((status) => {
      isRealtimeConnected.value = status === 'SUBSCRIBED'
    })
}

onMounted(async () => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
  await fetchLeads()
  await fetchSessions()
  setupRealtime()
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
  if (realtimeChannel) {
    supabase.removeChannel(realtimeChannel)
  }
})
</script>

<style scoped>
.live-chat-crm {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 4rem);
  max-height: calc(100vh - 4rem);
  gap: 1rem;
  overflow: hidden;
}

/* Header */
.crm-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}
.crm-title {
  font-size: 1.75rem;
  font-family: var(--font-heading);
  color: var(--c-primary-dark);
}
.crm-subtitle {
  color: var(--c-text-muted);
  font-size: 0.9rem;
}

.realtime-pill {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.4rem 0.85rem;
  border-radius: 99px;
  background-color: #fee2e2;
  color: #991b1b;
  font-size: 0.8rem;
  font-weight: 600;
}
.realtime-pill.connected {
  background-color: #d1fae5;
  color: #065f46;
}
.pulsing-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: currentColor;
  box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.4);
}

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 0.75rem;
  flex-shrink: 0;
}
.stat-card {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  background: white;
  padding: 0.7rem 1.15rem;
  border-radius: var(--radius);
  border: 1px solid var(--c-border);
  box-shadow: var(--shadow-sm);
}
.stat-icon {
  width: 38px;
  height: 38px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}
.bg-emerald { background-color: #10b981; }
.bg-amber { background-color: #f59e0b; }
.bg-blue { background-color: #3b82f6; }
.stat-num {
  display: block;
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--c-text-main);
  line-height: 1.1;
}
.stat-label {
  font-size: 0.75rem;
  color: var(--c-text-muted);
}

/* Workspace 3-Panel */
.crm-workspace {
  display: grid;
  grid-template-columns: 320px 1fr 340px;
  grid-template-rows: minmax(0, 1fr);
  gap: 0;
  flex: 1 1 0%;
  min-height: 0;
  background: white;
  border-radius: var(--radius);
  border: 1px solid var(--c-border);
  overflow: hidden;
  box-shadow: var(--shadow);
}

/* 1. Panel Contacts */
.panel-contacts {
  border-right: 1px solid var(--c-border);
  display: flex;
  flex-direction: column;
  background: #fbfcfd;
  min-height: 0;
  height: 100%;
  overflow: hidden;
}
.panel-header {
  padding: 1rem;
  border-bottom: 1px solid var(--c-border);
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  flex-shrink: 0;
}
.search-box {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: white;
  border: 1px solid var(--c-border);
  padding: 0.5rem 0.75rem;
  border-radius: var(--radius-sm);
}
.search-icon {
  color: var(--c-text-muted);
}
.search-input {
  border: none;
  outline: none;
  font-size: 0.85rem;
  width: 100%;
}
.filter-pills {
  display: flex;
  gap: 0.5rem;
}
.pill-btn {
  font-size: 0.75rem;
  padding: 0.35rem 0.65rem;
  border-radius: 99px;
  background: #f1f5f9;
  color: var(--c-text-muted);
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}
.pill-btn.active {
  background: var(--c-primary);
  color: white;
}
.contacts-list {
  flex: 1 1 0%;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  overscroll-behavior: contain;
  scrollbar-width: thin;
  scrollbar-color: #cbd5e1 #f1f5f9;
}
.contact-card {
  display: flex;
  gap: 0.75rem;
  padding: 0.85rem 1rem;
  border-bottom: 1px solid var(--c-border);
  border-left: 4px solid transparent;
  cursor: pointer;
  transition: background 0.15s, border-left-color 0.15s;
}
.contact-card:hover {
  background: #f1f5f9;
}
.contact-card.active {
  background: #e6f4ea;
  border-left-color: var(--c-primary);
}
.contact-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #e2e8f0;
  color: #475569;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.contact-info {
  flex: 1;
  min-width: 0;
}
.contact-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.15rem;
}
.contact-name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--c-text-main);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.contact-time {
  font-size: 0.75rem;
  color: var(--c-text-muted);
}
.contact-phone {
  font-size: 0.75rem;
  color: var(--c-text-muted);
  margin-bottom: 0.25rem;
}
.contact-preview {
  font-size: 0.8rem;
  color: #64748b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.survey-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  margin-top: 0.4rem;
  background: #fef3c7;
  color: #92400e;
  font-size: 0.7rem;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-weight: 600;
}

/* 2. Panel Chat */
.panel-chat {
  display: flex;
  flex-direction: column;
  background: #f8fafc;
  min-width: 0;
  min-height: 0;
  height: 100%;
  overflow: hidden;
}
.chat-header {
  padding: 0.85rem 1.25rem;
  background: white;
  border-bottom: 1px solid var(--c-border);
  display: flex;
  align-items: center;
  gap: 0.85rem;
  flex-shrink: 0;
}
.chat-user-avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: var(--c-primary-light);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.chat-user-meta {
  flex: 1;
}
.chat-user-meta h3 {
  font-size: 1rem;
  font-family: var(--font-body);
  font-weight: 700;
}
.chat-status {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.75rem;
  color: var(--c-text-muted);
}
.online-indicator {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #10b981;
}
.chat-header-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.action-btn-whatsapp {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.45rem 0.85rem;
  background: #25d366;
  color: white;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  font-weight: 600;
}
.action-btn-call {
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.45rem 0.85rem;
  background: #0284c7;
  color: white;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  font-weight: 600;
}

.messages-container {
  flex: 1 1 0%;
  min-height: 0;
  height: 100%;
  padding: 1.25rem;
  overflow-y: auto;
  overflow-x: hidden;
  overscroll-behavior: contain;
  display: flex;
  flex-direction: column;
  scroll-behavior: smooth;
  scrollbar-width: thin;
  scrollbar-color: #cbd5e1 #f1f5f9;
}
.messages-stream {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}
.message-row {
  display: flex;
  width: 100%;
}
.row-human {
  justify-content: flex-start;
}
.row-ai {
  justify-content: flex-end;
}
.message-bubble {
  max-width: 75%;
  padding: 0.75rem 1rem;
  border-radius: 12px;
  position: relative;
  box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}
.bubble-human {
  background: white;
  border: 1px solid var(--c-border);
  color: var(--c-text-main);
  border-bottom-left-radius: 2px;
}
.bubble-ai {
  background: #e6f4ea;
  border: 1px solid #c7e6d0;
  color: #064e3b;
  border-bottom-right-radius: 2px;
}
.sender-label {
  font-size: 0.7rem;
  font-weight: 700;
  color: var(--c-primary);
  margin-bottom: 0.25rem;
}
.bubble-human .sender-label {
  color: #475569;
}
.message-text {
  font-size: 0.88rem;
  line-height: 1.5;
  white-space: pre-wrap;
  word-break: break-word;
}
.message-meta {
  font-size: 0.68rem;
  color: var(--c-text-muted);
  text-align: right;
  margin-top: 0.35rem;
}

.chat-footer-notice {
  padding: 0.75rem 1rem;
  background: white;
  border-top: 1px solid var(--c-border);
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  color: var(--c-text-muted);
  flex-shrink: 0;
}

/* 3. Panel Details */
.panel-details {
  border-left: 1px solid var(--c-border);
  display: flex;
  flex-direction: column;
  background: white;
  min-height: 0;
  height: 100%;
  overflow: hidden;
}
.details-header {
  padding: 1rem 1.25rem;
  border-bottom: 1px solid var(--c-border);
  flex-shrink: 0;
}
.details-header h3 {
  font-size: 1rem;
  font-weight: 700;
  font-family: var(--font-body);
}
.details-content {
  padding: 1.25rem;
  overflow-y: auto;
  overflow-x: hidden;
  overscroll-behavior: contain;
  flex: 1 1 0%;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  scrollbar-width: thin;
  scrollbar-color: #cbd5e1 #f1f5f9;
}

/* Custom Scrollbars */
.messages-container::-webkit-scrollbar,
.contacts-list::-webkit-scrollbar,
.details-content::-webkit-scrollbar {
  width: 6px;
}
.messages-container::-webkit-scrollbar-track,
.contacts-list::-webkit-scrollbar-track,
.details-content::-webkit-scrollbar-track {
  background: #f1f5f9;
}
.messages-container::-webkit-scrollbar-thumb,
.contacts-list::-webkit-scrollbar-thumb,
.details-content::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 99px;
}
.messages-container::-webkit-scrollbar-thumb:hover,
.contacts-list::-webkit-scrollbar-thumb:hover,
.details-content::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}
.detail-section {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}
.highlight-card {
  background: #f8fafc;
  padding: 1rem;
  border-radius: var(--radius-sm);
  border: 1px solid var(--c-border);
}
.section-title {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--c-primary-dark);
  display: flex;
  align-items: center;
  gap: 0.4rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.field-label {
  font-size: 0.75rem;
  color: var(--c-text-muted);
  font-weight: 600;
  display: block;
  margin-bottom: 0.25rem;
}
.input-clean, .select-clean, .textarea-clean {
  width: 100%;
  padding: 0.6rem 0.75rem;
  border: 1px solid var(--c-border);
  border-radius: var(--radius-sm);
  font-family: inherit;
  font-size: 0.85rem;
  background: white;
}
.readonly-field {
  padding: 0.6rem 0.75rem;
  background: #f1f5f9;
  border-radius: var(--radius-sm);
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--c-text-main);
}
.btn-save-lead {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  width: 100%;
  padding: 0.75rem;
  background: var(--c-primary);
  color: white;
  border-radius: var(--radius-sm);
  font-weight: 600;
  font-size: 0.85rem;
  cursor: pointer;
  transition: background 0.2s;
  margin-top: 0.5rem;
}
.btn-save-lead:hover {
  background: var(--c-primary-dark);
}
.btn-save-lead:disabled {
  opacity: 0.7;
}

/* Placeholders & Empty States */
.no-selection, .empty-details, .empty-list {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  height: 100%;
  padding: 2rem;
  color: var(--c-text-muted);
}
.placeholder-icon, .empty-icon {
  color: #cbd5e1;
  margin-bottom: 1rem;
}
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  gap: 0.5rem;
  color: var(--c-text-muted);
}
.spin {
  animation: spin 1s linear infinite;
}
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.back-mobile-btn, .detail-toggle-btn {
  display: none;
}

/* Mobile Responsive */
@media (max-width: 900px) {
  .crm-workspace {
    grid-template-columns: 1fr;
  }
  .mobile-hidden {
    display: none !important;
  }
  .back-mobile-btn, .detail-toggle-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
    border-radius: var(--radius-sm);
    background: #f1f5f9;
  }
}
</style>
