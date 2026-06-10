import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '@/lib/supabase'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/admin/login',
    name: 'admin-login',
    component: () => import('@/views/admin/Login.vue')
  },
  {
    path: '/admin',
    name: 'admin',
    component: () => import('@/views/admin/Layout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'admin-dashboard',
        component: () => import('@/views/admin/Dashboard.vue')
      },
      {
        path: 'products',
        name: 'admin-products',
        component: () => import('@/views/admin/Products.vue')
      },
      {
        path: 'categories',
        name: 'admin-categories',
        component: () => import('@/views/admin/Categories.vue')
      },
      {
        path: 'inventory',
        name: 'admin-inventory',
        component: () => import('@/views/admin/Inventory.vue')
      },
      {
        path: 'pre-orders',
        name: 'admin-pre-orders',
        component: () => import('@/views/admin/PreOrders.vue')
      },
      {
        path: 'media',
        name: 'admin-media',
        component: () => import('@/views/admin/Media.vue')
      },
      {
        path: 'banners',
        name: 'admin-banners',
        component: () => import('@/views/admin/Banners.vue')
      },
      {
        path: 'social',
        name: 'admin-social',
        component: () => import('@/views/admin/Social.vue')
      },
      {
        path: 'analytics',
        name: 'admin-analytics',
        component: () => import('@/views/admin/Analytics.vue')
      },
      {
        path: 'settings',
        name: 'admin-settings',
        component: () => import('@/views/admin/Settings.vue')
      },
      {
        path: 'audit-logs',
        name: 'admin-audit-logs',
        component: () => import('@/views/admin/AuditLogs.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(async (to, from, next) => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (to.meta.requiresAuth && !session) {
    next('/admin/login')
  } else if (to.path === '/admin/login' && session) {
    next('/admin')
  } else {
    next()
  }
})

export default router