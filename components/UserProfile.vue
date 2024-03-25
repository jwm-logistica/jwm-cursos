<script setup>
const { signOut, data } = useAuth();

const isChecked = ref(false);

const props = defineProps({
    //a way to avoid unwanted responsivness in some cases
    maintainText: Boolean
});

async function handleSignOut() {
   await signOut({ callbackUrl: '/' });
}
</script>

<template>
    <div class="user-box">
        <div :class="props.maintainText ? 'text-area maintain' : 'text-area'">
            <h2>{{ data?.user.name.split("-")[1] }}</h2>
            <h3>Você está fazendo um bom progresso!</h3>
        </div>
        <div class="user-profile">
            <label @change="isChecked = !isChecked">
                <input type="checkbox">
                <NuxtImg :src="data?.user.image ? data?.user.image : '/user.jpg'" class="user-img" width="100%"/>
            </label>
            <Transition name="fade">
                <button v-if="isChecked" class="button-inverted shadow" @click="handleSignOut">
                    <Icon name="uil:signout" size="20px"/>
                </button>
            </Transition>
        </div>
    </div>
</template>

<style scoped>
/* import the courses.css so this page can change this style (responsivness purpose) */
@import url("~/assets/css/courses.css");

.user-box {
   display: flex;
   align-items: center;
   gap: 20px;
}

.user-img {
   width: 50px;
   height: 50px;
   border: 2px solid black;
   border-radius: 50%;
   overflow: hidden;
   cursor: pointer;
   object-fit: cover;
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

@media screen and (max-width: 660px) {
    .text-area:not(.maintain) {
        display: none;
    }
}
</style>
