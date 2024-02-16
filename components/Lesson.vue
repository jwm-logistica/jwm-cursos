<script setup>
const { lesson } = defineProps(["lesson"]);

const emit = defineEmits(["toggle"]);

const selectLesson = () => {
   const value = {
      selected: lesson.name,
      isVideo: lesson.isVideo,
      data: { title: "", text: "", videoUrl: "" },
   };

   emit("toggle", value);
};
</script>

<template>
   <transition name="fade">
      <div class="lesson" v-if="lesson.show">
         <CircleWBaseLine />
         <label @change="() => selectLesson()">
            <input type="radio" name="lesson" />
            <span>{{ lesson.name }}</span>
         </label>
      </div>
   </transition>
</template>

<style scoped>
input {
   box-shadow: none;
   display: none;
}

:checked + span {
   font-weight: bold;
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

      span {
         line-height: 17px;
      }
   }
}
</style>
