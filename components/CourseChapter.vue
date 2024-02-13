<script setup>
const { chapter } = defineProps(["chapter"]);

const isChecked = ref(false);
</script>

<template>
   <div class="chapter-dropdown">
      <label @change="isChecked = !isChecked">
         <input type="checkbox" />
         <div class="chapter-box bordered shadow">
            <span>{{ chapter.title }}</span>
         </div>
      </label>

      <transition name="fade">
         <div class="lessons" v-if="isChecked">
            <div class="lesson" v-for="lesson in chapter.lessons">
               <CircleWBaseLine />
               <label>
                  <input type="checkbox" />
                  <span>{{ lesson.name }}</span>
               </label>
            </div>
         </div>
      </transition>
   </div>
</template>

<style scoped>
input {
   box-shadow: none;
   display: none;
}

.chapter-dropdown {
   display: flex;
   flex-direction: column;
   align-items: center;
}

label {
   margin-bottom: 10px;
}

:checked + div {
   outline: 1px solid black;
}

.chapter-box {
   display: flex;
   align-items: center;
   padding: 20px;
   width: max-content;
   cursor: pointer;
}

.lessons {
   width: 100%;
}

.lesson {
   width: 100%;
   padding: 0px 30px 0px 30px;
   display: flex;
   align-items: flex-end;
   gap: 10px;

   label {
      display: flex;
      align-items: flex-end;
      margin: 0;
      cursor: pointer;

      span {
         line-height: 17px;
      }
   }
}
</style>
