<script setup>
const { signIn } = useAuth();

const email = ref('') 
const password = ref('')

definePageMeta({
  auth: {
    unauthenticatedOnly: true,
    navigateAuthenticatedTo: '/courses',
  },
})
</script>

<template>
   <div id="inner-body-login">
      <div class="shadow login-box">
         <div class="login-head">
            <img src="/logo.png" width="200" />
            <div class="title-box">
               <h1 class="red-font">CURSOS</h1>
               <div class="line" />
               <h1>LOGIN</h1>
            </div>
            <h3>Acesse sua área de cursos JWM</h3>
         </div>

         <form @submit.prevent="() => signIn('credentials', {email, password})">
            <div class="login-input-section">
               <input v-model="email" placeholder="Email" type="email" name="email" required/>
               <input v-model="password" placeholder="Senha" type="password" name="password" required/>
            </div>
            
            <button type="submit" class="button-main">LOGIN</button>
         </form>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/login.css");
</style>
