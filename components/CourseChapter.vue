<script setup>
const props = defineProps({
  chapter: Object
});

const { chapter } = props;

const lessons = toRef(chapter.lessons);

const emit = defineEmits(["chapterSelection", "lessonSelection"]);

const buttonRef = ref('');

//whenever a chapter is selected, all the chapters will call the function to (un)show the lessons
watch(() => props.chapter, (newValue) => {
   onChapterCheck(newValue.active);
}, { deep: true })

watch(() => props.chapter.lessons, (newValue) => {
   lessons.value = newValue;
}, { deep: true })

let timeoutID = null;
const onChapterCheck = show => {
   //this is a function that shows one lesson after the other with a certain delay
   const timeInMS = 200;
   clearTimeout(timeoutID);

   if (show) {
      //coming
      for (let i = 0; i < lessons.value.length; i++) {
         const delay = timeInMS * i;
         timeoutID = setTimeout(() => {
            lessons.value[i].show = show;
         }, delay);
      }

      buttonRef.value.classList.remove('shadow');
      buttonRef.value.classList.add('darker-shadow');
   } else {
      //going 
      for (let i = lessons.value.length - 1; i >= 0; i--) {
         const delay = timeInMS * (lessons.value.length - 1 - i);
         timeoutID = setTimeout(() => {
            lessons.value[i].show = show;
         }, delay);
      }

      buttonRef.value.classList.remove('darker-shadow');
      buttonRef.value.classList.add('shadow');

      //unselect any selected lesson
      onLessonSelection(null);
   }
};

const onLessonSelection = number => {
   emit("lessonSelection", number);
};

const handleClick = () => {
   emit("chapterSelection", chapter.number);
}
</script>

<template>
   <div class="chapter-dropdown">
      <button ref="buttonRef" @click="handleClick" class="chapter-box bordered shadow">
         <span>{{ chapter.name }}</span>
      </button>

      <div class="lessons">
         <Lesson
            v-for="lesson in lessons"
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
