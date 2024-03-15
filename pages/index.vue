<script setup>
const { signIn } = useAuth();

const email = ref('') 
const password = ref('')

const route = useRoute();
const error = route.query.error;
const showError = ref(false)

if(error) {
   showError.value = true;
}

definePageMeta({
  auth: {
    unauthenticatedOnly: true,
    navigateAuthenticatedTo: '/courses',
  },
})

const handleSignIn = (email, password) => {
   signIn('credentials', {email, password})
}
</script>

<template>
   <div id="inner-body-login">
      <div class="shadow login-box">
         <div class="login-head">
            <img src="/logo.png" />
            <div class="title-box">
               <h1 class="red-font">CURSOS</h1>
               <div class="line" />
               <h1>LOGIN</h1>
            </div>
            <h3>Acesse sua área de cursos JWM</h3>
         </div>

         <form @submit.prevent="() => handleSignIn(email, password)">
            <div class="login-input-section">
               <input v-model="email" placeholder="Email" type="email" name="email" required/>
               <input v-model="password" placeholder="Senha" type="password" name="password" required/>
            </div>
            
            <button type="submit" class="button-main">LOGIN</button>
         </form>
      </div>
      <Transition name="fade" appear>
         <div class="error shadow" v-show="showError">
            <p>Email e/ou Senha incorreto(s)</p>
            <button class="button-main" @click.prevent="() => showError=false">Fechar</button>
         </div>
      </Transition>
   </div>
</template>

<style scoped>
@import url("~/assets/css/login.css");
</style>
