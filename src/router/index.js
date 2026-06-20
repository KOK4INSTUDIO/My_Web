import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '@/lib/supabase'

const routes = [
  {
    path: '/',
    name: 'landing',
    component: () => import('@/views/Landing.vue')
  },
  {
    path: '/auth',
    name: 'auth',
    component: () => import('@/views/LandingLogin.vue')
  },
  {
    path: '/user/login',
    name: 'user-login',
    component: () => import('@/views/user/UserLogin.vue')
  },
  {
    path: '/user/register',
    name: 'user-register',
    component: () => import('@/views/user/UserRegister.vue')
  },
  {
    path: '/home',
    name: 'user',
    component: () => import('@/views/user/Layout.vue'),
    meta: { requiresUserAuth: true },
    children: [
      {
        path: '',
        name: 'user-home',
        component: () => import('@/views/user/Home.vue')
      },
      {
        path: 'products',
        name: 'user-products',
        component: () => import('@/views/user/Products.vue')
      },
      {
        path: 'product/:slug',
        name: 'user-product-detail',
        component: () => import('@/views/user/ProductDetail.vue')
      },
      {
        path: 'about',
        name: 'user-about',
        component: () => import('@/views/user/Portfolio.vue')
      },
      {
        path: 'services',
        name: 'user-services',
        component: () => import('@/views/user/Services.vue')
      },
      {
        path: 'contact',
        name: 'user-contact',
        component: () => import('@/views/user/Contact.vue')
      }
    ]
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
        path: 'products/category/:categoryId',
        name: 'admin-products-by-category',
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
        path: 'analytics',
        name: 'admin-analytics',
        component: () => import('@/views/admin/Analytics.vue')
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
  
  // Auth for admin
  if (to.meta.requiresAuth && !session) {
    next('/admin/login')
  } else if (to.path === '/admin/login' && session) {
    next('/admin')
  } 
  // Auth for user
  else if (to.meta.requiresUserAuth && !session) {
    next('/auth')
  } 
  // Redirect to home if user is already logged in and tries to access landing/login/register
  else if (session && (to.path === '/auth' || to.path === '/user/login' || to.path === '/user/register')) {
    next('/home')
  }
  else {
    next()
  }
})

export default router
