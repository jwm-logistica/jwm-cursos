// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ['@sidebase/nuxt-auth', 'nuxt-icon'],
  auth: {
    globalAppMiddleware: true
   },
	css: ['~/assets/css/main.css'],
  devtools: { enabled: true }
})
