<script setup>
const { signOut } = useAuth();

const isChecked = ref(false);

async function handleSignOut() {
   await signOut({ callbackUrl: '/' });
}
</script>   

<template>
   <div class="header-box">
      <img src="/logo.png" height="80" alt="Logo da empresa JWM Soluções Logísticas" />
      <div class="user-box">
         <div>
            <h2>OLÁ USUÁRIO</h2>
            <h3>Você está fazendo um bom progresso!</h3>
         </div>
         <div class="user-profile">
            <label @change="isChecked = !isChecked">
               <input type="checkbox">
               <img src="/user.png" class="user-img" width="100%" />
            </label>
            <Transition name="fade">
               <button v-if="isChecked" class="button-inverted" @click="handleSignOut">
                  <Icon name="uil:signout" size="20px"/>
               </button>
            </Transition>
         </div>
      </div>
   </div>
</template>

<style scoped>
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
   cursor: pointer;
}

.user-profile {
   width: fit-content;
   height: fit-content;
   display: flex;
   justify-content: flex-end;
   align-items: flex-end;
}

input {
   display: none;
}

.button-inverted {
   position: absolute;
   transform: translateY(50%);
   padding: 5px;
   border-radius: 3px;
}

.button-inverted:hover {
   outline: 1px solid #e31c24;
}
</style>
