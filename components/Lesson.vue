<script setup>
const props = defineProps({
   lesson: Object
});

const lesson = props.lesson;

const emit = defineEmits(["toggle"]);

const selectLesson = () => {
   emit("toggle", lesson.number);
};
</script>

<template>
   <transition name="fade">
      <div class="lesson" v-if="lesson.show">
         <CircleWBaseLine />
         <label @change="() => selectLesson()">
            <input type="radio" name="lesson" />
            <div class="lesson-name-icon">
               <span>{{ lesson.name }}</span>
               <Icon name="ic:baseline-ondemand-video" size="20px" class="main-icon" v-if="lesson.type == 'VIDEO'"/>
               <Icon name="mdi:file-document-edit-outline" size="20px" class="main-icon" v-if="lesson.type == 'TEST'"/>
            </div>
         </label>
      </div>
   </transition>
</template>

<style scoped>
input {
   box-shadow: none;
   display: none;
}

:checked + div {
   * {
      font-weight: bold;
   }
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

.lesson-name-icon {
   display: flex;
   align-items: center;
   gap: 10px;

   span {
      line-height: 17px;
   }
}
</style>
