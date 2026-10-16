import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '@/lib/supabase'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/LandingPage.vue') // ini akan kita perbarui isinya menjadi katalog
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('../views/AboutPage.vue')
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('../views/ContactPage.vue')
    },
    {
      path: '/property/:slug',
      name: 'property-detail',
      component: () => import('../views/PropertyDetail.vue')
    },
    {
      path: '/kelola-griya/login',
      name: 'admin-login',
      component: () => import('../views/AdminLogin.vue')
    },
    {
      path: '/kelola-griya',
      component: () => import('../views/AdminLayout.vue'),
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          name: 'admin-dashboard',
          component: () => import('../views/AdminDashboard.vue')
        },
        {
          path: 'live-chat',
          name: 'admin-live-chat',
          component: () => import('../views/AdminLiveChat.vue')
        },
        {
          path: 'property/new',
          name: 'admin-property-new',
          component: () => import('../views/AdminPropertyForm.vue')
        },
        {
          path: 'property/:id/edit',
          name: 'admin-property-edit',
          component: () => import('../views/AdminPropertyForm.vue')
        },
        {
          path: 'settings',
          name: 'admin-settings',
          component: () => import('../views/AdminSettings.vue')
        },
        {
          path: 'users',
          name: 'admin-users',
          component: () => import('../views/AdminUsers.vue')
        }
      ]
    }
  ],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

// View Transitions API Hook
router.beforeResolve(async (to, from) => {
  if (to.path === from.path) return
  
  // Jika browser tidak support, langsung pindah
  if (!document.startViewTransition) {
    return
  }

  // Bungkus resolusi rute di dalam startViewTransition
  return new Promise(resolve => {
    document.startViewTransition(async () => {
      resolve()
      // Beri sedikit jeda agar DOM Vue selesai update sebelum animasi berjalan
      await new Promise(r => setTimeout(r, 0))
    })
  })
})

// Navigation Guard
router.beforeEach(async (to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  
  if (requiresAuth) {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      next({ name: 'admin-login' })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
