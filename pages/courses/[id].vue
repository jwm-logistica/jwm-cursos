<script setup>
const route = useRoute();
const { id } = route.params;
const userId = route.query.userId;

const { data, pending } = await useAsyncData('user-course-chapters', async () => {
   const [ course, chapters ] = await Promise.all([
      $fetch('/api/course', { params: { id: id, userId: userId }}),
      $fetch('/api/chapters', { params: { id: id }})
   ])

   return { ...course, ...chapters }
})

const course = ref(data.value.course);
const chapters = ref(data.value.chapters.map((chapter) => {
   const lessons = chapter.lessons.map(lesson => {
      return {
         ...lesson,
         active: false,
         show: false,
      }
   })
   return { ...chapter, lessons: lessons, active: false }
}))

const chapterSelected = ref({
   number: chapters.value[0].number,
   name: chapters.value[0].name,
   title: chapters.value[0].title,
   description: chapters.value[0].description,
   lessons: chapters.value[0].lessons
});

const defaultSelectedLesson = {
   number: -1,
   name: '',
   type: 'VIDEO',
   videoUrl: '',
   completed: false,
}

const lessonSelected = ref(defaultSelectedLesson);

const chapterSelection = (chapterNumber) => {
   //desactivate all the chapters except for the selected one (if it is already selected, then desactivate too)
   chapters.value = chapters.value.map(chapter => ({
      ...chapter,
      active: chapter.number === chapterNumber && !chapter.active,
   }));

   chapterSelected.value = chapters.value.find(chapter => chapter.number === chapterNumber);

   //resets the value of the lesson
   lessonSelected.value = defaultSelectedLesson;
};

const updateUserHistory = async(lessonNumber, chapterNumber) => {
   await $fetch('/api/history', {
      method: 'POST',
      body: {
         userId: parseInt(userId),
         lessonNumber: lessonNumber,
         chapterNumber: chapterNumber,
         completed: true,
      }
   }).then(async() => {
      //update client side
      lessonSelected.value.completed = true;

      //updating lesson completion and progress client side
      let progress = 0;
      chapters.value.forEach(chapter => {
         const lessonIndex = chapter.lessons.findIndex(lesson => lesson.number == lessonNumber);
         
         if(lessonIndex != -1) {
            //update chapters first to be always upToDate when anything access it
            chapter.lessons[lessonIndex].completed = true;
         }

         const allCompleted = chapter.lessons.every(lesson => lesson.completed);

         if(allCompleted) {
            progress++;
         }
      })

      await $fetch('/api/progress', {
         method: 'PUT',
         body: {
            userId: parseInt(userId),
            courseId: course.value.id,
            progress: progress,
         }
      }).then(() => {
         course.value.progress = progress;
      })

      //update the current selected chapter with the new lesson done
      const chapterIndex = chapters.value.findIndex(chapter => chapter.number == chapterNumber);
      if(chapterIndex != -1) {
         chapterSelected.value = chapters.value[chapterIndex];
      }
   })
}

const nextLesson = async() => {
   updateUserHistory(lessonSelected.value.number, chapterSelected.value.number)

   //go to the next question  
   const actualLessonIndex = chapterSelected.value.lessons.findIndex(lesson => lesson.number == lessonSelected.value.number);

   let nextLesson = defaultSelectedLesson;
   if(actualLessonIndex + 1 < chapterSelected.value.lessons.length) {
      //the next lesson is from the same chapter
      nextLesson = chapterSelected.value.lessons[actualLessonIndex+1];
      lessonSelection(nextLesson.number);
   } else {  
      const actualChapterIndex = chapters.value.findIndex(chapter => chapter.number == chapterSelected.value.number);
      if(actualChapterIndex + 1 < chapters.value.length) {
         //the next lesson is from the next chapter
         const nextChapter = chapters.value[actualChapterIndex+1];
         chapterSelection(nextChapter.number);

         lessonSelection(null);
      } else {
         //there's no next chapter, change the button to goes to the main selection page
      }
   }
}

const lessonSelection = (lessonNumber) => {
   //desactivate all the lessons except for the selected one (if it is already selected or the chapter is inactive, then desactivate too)
   chapterSelected.value.lessons = chapterSelected.value.lessons.map(lesson => {
      return {
         ...lesson,
         active: lesson.number === lessonNumber && !lesson.active
      }
   });

   if(lessonNumber) {
      lessonSelected.value = chapterSelected.value.lessons.find(lesson => lesson.number == lessonNumber);
   } else {
      //resets the value of the lesson
      lessonSelected.value = defaultSelectedLesson;
   }
}

const getMaxTitleWidth = () => {
   const sideBarWidth = process.client ? document.getElementById('side-bar').offsetWidth : 325;
   //maxTitleWidth is composed from the window width size - (paddings on the page (2*55px) + gap (55px) + side-bar maxwidth)
   return process.client ? window.innerWidth - (4*55 + sideBarWidth) : 940;
}
</script>

<template>
   <div id="inner-body-course" class="spaced-body">
      <AppHeader />

      <div id="view-body-course">
         <div class="side-bar" id="side-bar">
            <div class="back-and-progress">
               <NuxtLink to="/courses" class="red-font">Voltar</NuxtLink>
               <ProgressBar :progress="(course.progress / chapters.length) * 100"/>
               <span class="lighter">{{ course.progress + '/' + chapters.length }}</span>
            </div>
            <CourseChapter
               v-for="chapter in chapters"
               :key="chapter.number"
               :chapter="chapter"
               @chapterSelection="number => chapterSelection(number)"
               @lessonSelection="number => lessonSelection(number)"
            />
         </div>

         <div class="chapter-view">
            <div class="chapter-text">
               <div>
                  <!-- Client only to avoid hidration mismatch -->
                  <ClientOnly>
                     <div class="course-chapter-title" :style="'max-width:'+getMaxTitleWidth()+'px'">
                        <h1 class="red-font" style="white-space: nowrap;">{{ course.name }}</h1>
                        <div class="line" />
                        <h1>{{ chapterSelected.name }}</h1>
                     </div>
                  </ClientOnly>
                  <h2 v-if="lessonSelected.type == 'VIDEO'"> {{ chapterSelected.title }}</h2>
                  <h2 v-else>{{ lessonSelected.name }}</h2>
               </div>

               <ClientOnly>
                  <!-- ClientOnly is to prevent a warning caused by white-space:pre-line -->
                  <p style="white-space: pre-line;" v-if="lessonSelected.type == 'VIDEO'">{{ chapterSelected.description }} </p>
               </ClientOnly>
            </div>

            <div class="chapter-video-box" v-if="lessonSelected.type == 'VIDEO' && lessonSelected.videoUrl != '' ">
               <h2>{{ lessonSelected.name }}</h2>
               <div class="chapter-video bordered shadow" />
            </div>
            <div class="next-lesson-button-box" v-if="lessonSelected.type == 'VIDEO' && lessonSelected.number != -1">
               <button class="shadow bordered button-main" style="width:fit-content" @click="nextLesson">
                  <span>PRÓXIMA AULA</span>
                  <Icon name="ic:baseline-keyboard-arrow-right" size="25px"/>
               </button>
            </div>

            <ChapterTest 
               v-if="!pending && !(lessonSelected.type == 'VIDEO')"
               :lessonNumber="+lessonSelected.number"
               :chapterNumber="+chapterSelected.number"
               @nextLesson="nextLesson"
            />
         </div>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/course.css");
</style>
