<script setup>
const props = defineProps({
  chapter: Object
});

const { chapter } = props;

const lessons = toRef(chapter.lessons);

const emit = defineEmits(["chapterSelection", "lessonSelection"]);

const buttonRef = ref('');

//whenever a chapter is selected, all the chapters will call the function to (un)show the lessons
watch(() => props.chapter, (newValue, oldValue) => {
   if (newValue.active !== oldValue.active) {
      onChapterCheck(newValue.active);
   }
   lessons.value = newValue.lessons;
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

const handleClick = (number) => {
   emit("chapterSelection", number);
}
</script>

<template>
   <div class="chapter-dropdown">
      <button 
         ref="buttonRef"
         @click="() => handleClick(chapter.number)" 
         class="chapter-box bordered shadow"
         :style="chapter.completed ? 'justify-content: space-between' : ''"
      >
         <span>{{ chapter.name }}</span>
         <Icon name="ic:outline-check" v-if="chapter.completed"/>
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

.icon {
   min-width: 24px;
   min-height: 24px;
}
.icon > :not(svg) {
   color: #e31c24 !important;
}
</style>
