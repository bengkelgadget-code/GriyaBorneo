/**
 * Formats a number to Indonesian Rupiah currency format.
 * @param {number} value
 * @returns {string}
 */
export function formatPrice(value) {
  if (value === undefined || value === null) return 'Rp 0'
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value)
}

/**
 * Formats a Date string into Indonesian date format.
 * @param {string|Date} dateString
 * @returns {string}
 */
export function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

/**
 * Generates a URL-friendly slug from a string.
 * @param {string} text
 * @returns {string}
 */
export function generateSlug(text) {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')        // Replace spaces with -
    .replace(/[^\w-]+/g, '')     // Remove all non-word chars
    .replace(/--+/g, '-')        // Replace multiple - with single -
    .replace(/^-+/, '')          // Trim - from start of text
    .replace(/-+$/, '')          // Trim - from end of text
}

/**
 * Generates a WhatsApp URL with a pre-filled message.
 * @param {string} phone
 * @param {string} propertyTitle
 * @returns {string}
 */
export function generateWhatsAppUrl(phone, propertyTitle = null) {
  let cleanPhone = phone.replace(/\D/g, '')
  if (cleanPhone.startsWith('0')) {
    cleanPhone = '62' + cleanPhone.substring(1)
  }
  
  let text = 'Halo Griya Borneo Property, saya ingin bertanya tentang '
  if (propertyTitle) {
    text += `properti: *${propertyTitle}*.`
  } else {
    text += 'properti yang tersedia.'
  }
  
  const encodedText = encodeURIComponent(text)
  return `https://wa.me/${cleanPhone}?text=${encodedText}`
}
