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

   changeTextStyle();
}, { deep: true })

const textRef = ref(null);

const changeTextStyle = () => {
   if(textRef.value) {
      if(active.value) {
         textRef.value.classList.add('active')
      } else {
         textRef.value.classList.remove('active')
      }
   
      if(completed.value) {
         textRef.value.classList.add('completed')
      } else {
         textRef.value.classList.remove('completed')
      }
   }
}

const selectLesson = () => {
   emit("toggle", lesson.number);
};
</script>

<template>
   <transition name="fade">
      <div class="lesson" v-if="show">
         <CircleWBaseLine :active="active" :completed="completed"/>
         <button class="lesson-button" @click="selectLesson">
            <div class="lesson-name-icon">
               <span ref="textRef" :class="completed ? 'lesson-name completed' : 'lesson-name'">{{ lesson.name }}</span>
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
   transform-origin: center;
}

.lesson-button:active {
   transform: translate(5px, 5px);
}

.lesson-name-icon {
   display: flex;
   align-items: center;
   gap: 10px;

   span {
      line-height: 17px;
   }
}

.active {
   font-weight: bold;
}

.completed {
   text-decoration: line-through #e31c24;
}

.main-icon {
   min-width: 20px;
   min-height: 20px;
}

@media screen and (max-width: 400px) {
   .lesson-name {
      text-overflow: ellipsis;
      text-wrap: nowrap;
      overflow: hidden;
   }

   .lesson-name-icon {
      max-width: 100%;
   }

   .lesson-button {
      max-width: 100%;
   }
}
</style>
