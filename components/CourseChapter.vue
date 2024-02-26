<script setup>
const props = defineProps({
  chapter: Object
});

const { chapter } = props;

const chapterLessons = chapter.lessons.map(lesson => {
   return { ...lesson, show: false, active: false };
});

const chapterLessonsRef = ref(chapterLessons);

const emit = defineEmits(["chapterSelection", "lessonSelection"]);

watch(() => props.chapter, (newValue) => {
   onChapterCheck(newValue.active);
}, { deep: true })

let timeoutID = null;
const onChapterCheck = show => {
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

const onLessonSelection = number => {
   chapterLessonsRef.value = chapterLessonsRef.value.map(lesson => ({
      ...lesson,
      active: lesson.number === number && !lesson.active
   }));

   emit("lessonSelection", number);
};

const handleClick = () => {
   emit("chapterSelection", chapter.number);
}
</script>

<template>
   <div class="chapter-dropdown">
      <button @click="handleClick" class="chapter-box bordered shadow">
         <span>{{ chapter.name }}</span>
      </button>

      <div class="lessons">
         <Lesson
            v-for="lesson in chapterLessonsRef"
            :lesson="lesson"
            @toggle="number => onLessonSelection(number)"
         />
      </div>
   </div>
</template>

<style scoped>
.chapter-dropdown {
   display: flex;
   flex-direction: column;
   align-items: center;
}

.chapter-box {
   display: flex;
   background-color: #fbfbfb;
   align-items: center;
   text-align: start;
   padding: 20px;
   width: 100%;
   cursor: pointer;
   min-width: 325px;
   margin-bottom: 10px;
}

.lessons {
   width: 100%;
}
</style>
