<script setup>
const props = defineProps({
   lesson: Object
});

const lesson = props.lesson;

const emit = defineEmits(["toggle"]);

const show = ref(false);
const active = ref(false);
const completed = ref(false);

watch(() => props.lesson, (newValue) => {
   active.value = newValue.active;
   show.value = newValue.show;
   completed.value = newValue.completed;
}, { deep: true })

const selectLesson = () => {
   emit("toggle", lesson.number);
};
</script>

<template>
   <transition name="fade">
      <div class="lesson" v-if="show">
         <CircleWBaseLine :active="active"/>
         <button class="lesson-button" @click="selectLesson">
            <div class="lesson-name-icon">
               <span :style="
                  active ? 'font-weight: bold' : '' 
                  + completed ? 'text-decoration: line-through #e31c24; ' : ''
               ">{{ lesson.name }}</span>
               <Icon name="ic:baseline-ondemand-video" size="20px" class="main-icon" v-if="lesson.type == 'VIDEO'"/>
               <Icon name="mdi:file-document-edit-outline" size="20px" class="main-icon" v-if="lesson.type == 'TEST'"/>
            </div>
         </button>
      </div>
   </transition>
</template>

<style scoped>
input {
   box-shadow: none;
   display: none;
}

label {
   margin-bottom: 10px;
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

      
   }
}

.lesson-button {
   border-radius: 5px;
   padding: 4px 10px;
   transform: translateY(5px);
}

.lesson-name-icon {
   display: flex;
   align-items: center;
   gap: 10px;

   span {
      line-height: 17px;
   }
}
</style>
