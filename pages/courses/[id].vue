<script setup>
import { vueVimeoPlayer } from 'vue-vimeo-player'

const route = useRoute();
const router = useRouter();
const { id } = route.params;
const userId = route.query.userId;

const { data, pending } = await useAsyncData('user-course-chapters', async () => {
   const [ course, chapters, history ] = await Promise.all([
      $fetch('/api/course', { params: { id: id, userId: userId }}),
      $fetch('/api/chapters', { params: { id: id }}),
      $fetch('/api/history', {params: { userId: userId }})
   ])

   return { ...course, ...chapters, ...history }
})

const completedChapter = (chapterLessons, currentLessonNumber) => {
   const lessonIndex = chapterLessons.findIndex(lesson => lesson?.number == currentLessonNumber);

   if(lessonIndex != -1) {
      //if found the lesson, then update it to completed
      chapterLessons[lessonIndex].completed = true;
   }

   if(chapterLessons.length == 0) {
      return false;
   } else {
      return chapterLessons.every(lesson => lesson.completed);
   }
}

const course = ref(data.value.course);
const chapters = ref(data.value.chapters.map((chapter) => {
   const lessons = chapter.lessons.map(lesson => {
      const lessonFromHistory = data.value.history.find(hist => hist.lesson.number == lesson.number);

      return {
         ...lesson,
         active: false,
         show: false,
         completed: lessonFromHistory?.completed ? lessonFromHistory.completed : false
      }
   })

   return { ...chapter, lessons: lessons, active: false, completed: completedChapter(lessons) }
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
      active: chapter.number == chapterNumber && !chapter.active,
   }));

   chapterSelected.value = chapters.value?.find(chapter => chapter.number == chapterNumber);

   //resets the value of the lesson
   lessonSelected.value = defaultSelectedLesson;
};

let alreadyUpdated = false;

const updateUserHistory = async(lessonNumber, chapterNumber) => {
   //if the user history was already called by the video percentage or test finish, so the update will not happen
   //this is to avoid multiple calls by the video ending and when user finishes the test and press the finish button (nextLesson call) again
   if(!alreadyUpdated) {
      await $fetch('/api/history', {
         method: 'POST',
         body: {
            userId: parseInt(userId),
            lessonNumber: lessonNumber,
            chapterNumber: chapterNumber,
            completed: true,
         }
      }).then(async() => {
         //updating lesson completion and progress client side
         let progress = 0;
         chapters.value.forEach(chapter => {
            if(completedChapter(chapter.lessons, lessonNumber)) {
               progress++;

               //update client side
               chapter.completed = true;
            }
         })
   
         await $fetch('/api/progress', {
            method: 'PUT',
            body: {
               userId: parseInt(userId),
               courseId: course.value.id,
               progress: progress,
               average: null,
            }
         }).then(() => {
            course.value.progress = progress;
         })

         alreadyUpdated = true;
      })
   }
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
      const currentChapterIndex = chapters.value.findIndex(chapter => chapter.number == chapterSelected.value.number);
      if(currentChapterIndex + 1 < chapters.value.length) {
         //the next lesson is from the next chapter
         const nextChapter = chapters.value[currentChapterIndex+1];
         chapterSelection(nextChapter.number);

         lessonSelection(null);
      } else {
         //there's no next chapter, change the button to goes to the main selection page
         router.push('/courses')
      }
   }
}

const lessonSelection = (lessonNumber) => {
   alreadyUpdated = false;

   //desactivate all the lessons except for the selected one (if it is already selected or the chapter is inactive, then desactivate too)
   chapterSelected.value.lessons = chapterSelected.value.lessons.map(lesson => {
      return {
         ...lesson,
         active: lesson.number == lessonNumber
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

const onVideoProgress = (data) => {
   if(data.percent >= 0.9) {
      //when video percentage is above 90%, tries to update the user history only one time
      updateUserHistory(lessonSelected.value.number, chapterSelected.value.number);
   }
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
               <div class="chapter-video bordered shadow">
                  <vue-vimeo-player ref="player" @progress="onVideoProgress" :video-url="lessonSelected.videoUrl" :options="{responsive: true}"/>
               </div>
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
