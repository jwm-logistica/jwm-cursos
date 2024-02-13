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

         <div class="login-input-section">
            <input placeholder="Email" />
            <input placeholder="Senha" />
         </div>

         <NuxtLink to="/courses">
            <button>LOGIN</button>
         </NuxtLink>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/login.css");
</style>
