// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ['@sidebase/nuxt-auth', 'nuxt-icon', "@nuxt/image"],
  auth: {
    globalAppMiddleware: true,
    baseURL: process.env.NUXT_AUTH_ORIGIN,
    origin: process.env.NUXT_AUTH_ORIGIN
  },
  app: {
    head: {
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },
  $production: {
    routeRules: {
      '/**': { isr: true }
    }
  },
  runtimeConfig: {
    AUTH_SECRET: process.env.AUTH_SECRET,
    authOrigin: process.env.NUXT_AUTH_ORIGIN
  },
	css: ['~/assets/css/main.css'],
  devtools: { enabled: true }
})