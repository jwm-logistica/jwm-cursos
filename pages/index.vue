<script setup>
const { signIn } = useAuth();

const login = ref('') 
const password = ref('')

const showError = ref(false)

definePageMeta({
  auth: {
    unauthenticatedOnly: true,
    navigateAuthenticatedTo: '/courses',
  },
})

const handleSignIn = async (login, password) => {
   const {error} = await signIn('credentials', {login, password, redirect: false})

   if(error) {
      showError.value = true;
   } else {
      return navigateTo('/courses', {external: true});
   }
}

const formatCPF = () => {
   login.value = login.value.replace(/\D/g, "");
   login.value = login.value.replace(/(\d{3})(\d)/, "$1.$2");
   login.value = login.value.replace(/(\d{3})(\d)/, "$1.$2");
   login.value = login.value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
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
               <h1>ACESSO</h1>
            </div>
            <h3>Acesse sua área de cursos JWM</h3>
         </div>

         <form @submit.prevent="() => handleSignIn(login, password)">
            <div class="login-input-section">
               <input v-model="login" placeholder="Login" name="login" required @input="formatCPF" maxlength="14"/>
               <input v-model="password" placeholder="Senha" type="password" name="password" required/>
            </div>
            
            <button type="submit" class="button-main">ENTRAR</button>
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
