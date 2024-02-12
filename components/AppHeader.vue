<template>
   <div class="header-box">
      <img src="/logo.png" height="80" />
      <div class="user-box">
         <div>
            <h2>OLÁ USUÁRIO</h2>
            <h3>Você está fazendo um bom progresso!</h3>
         </div>
         <div class="user-img">
            <img src="/user.png" width="100%" />
         </div>
      </div>
   </div>
</template>

<style>
.header-box {
   width: 100%;
   display: flex;
   align-items: center;
   justify-content: space-between;
   margin-bottom: 40px;
}

.user-box {
   display: flex;
   align-items: center;
   gap: 20px;
}

.user-img {
   padding: 5px;
   width: 50px;
   height: 50px;
   border: 2px solid black;
   border-radius: 50%;
   overflow: hidden;
}
</style>
