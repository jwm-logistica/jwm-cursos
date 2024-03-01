// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ['@sidebase/nuxt-auth', 'nuxt-icon', "@nuxt/image"],
  auth: {
    globalAppMiddleware: true,
    baseURL: process.env.NUXT_AUTH_ORIGIN
  },
  runtimeConfig: {
    AUTH_SECRET: process.env.AUTH_SECRET
  },
	css: ['~/assets/css/main.css'],
  devtools: { enabled: true },
})