<script setup>
const { chapter } = defineProps(["chapter"]);

const chapterLessons = chapter.lessons.map(lesson => {
   return { ...lesson, show: false };
});
const chapterLessonsRef = ref(chapterLessons);

const isChecked = ref(false);

const emit = defineEmits(["chapterSelection", "lessonSelection"]);
const onChapterSelection = value => {
   emit("chapterSelection", value);
};

let timeoutID = null;
const onChapterCheck = show => {
   onChapterSelection(chapter);

   const timeInMS = 200;
   clearTimeout(timeoutID);

   if (show) {
      //coming
      for (let i = 0; i < chapterLessons.length; i++) {
         const delay = timeInMS * i;
         timeoutID = setTimeout(() => {
            chapterLessonsRef.value[i].show = show;
         }, delay);
      }
   } else {
      //going 
      for (let i = chapterLessons.length - 1; i >= 0; i--) {
         const delay = timeInMS * (chapterLessons.length - 1 - i);
         timeoutID = setTimeout(() => {
            chapterLessonsRef.value[i].show = show;
         }, delay);
      }
   }
};

const onLessonSelection = value => {
   emit("lessonSelection", value);
};
</script>

<template>
   <div class="chapter-dropdown">
      <label
         @change="
            () => {
               isChecked = !isChecked;
               onChapterCheck(isChecked);
            }
         "
      >
         <input type="checkbox" />
         <div class="chapter-box bordered shadow">
            <span>{{ chapter.name }}</span>
         </div>
      </label>

      <div class="lessons">
         <Lesson
            v-for="lesson in chapterLessonsRef"
            :lesson="lesson"
            @toggle="value => onLessonSelection(value)"
         />
      </div>
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
   width: 100%;
   cursor: pointer;
   min-width: 325px;
}

.lessons {
   width: 100%;
}
</style>
