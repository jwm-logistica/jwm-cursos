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

const course = data.value.course;
const chapters = ref(data.value.chapters.map((chapter) => {
   return { ...chapter, active: false }
}))

const chapterSelected = ref({
   number: chapters.value[0].number,
   name: chapters.value[0].name,
   title: chapters.value[0].title,
   description: chapters.value[0].description,
   lessons: chapters.value[0].lessons
});

const lessonSelected = ref({
   number: -1,
   name: '',
   type: 'VIDEO',
   videoUrl: '',
});

const chapterSelection = (chapterNumber) => {
   //desactivate all the chapters except for the selected one (if it is already selected, then desactivate too)
   chapters.value = chapters.value.map(chapter => ({
      ...chapter,
      active: chapter.number === chapterNumber && !chapter.active
   }));

   chapterSelected.value = chapters.value.find(chapter => chapter.number === chapterNumber);

   //resets the value of the lesson
   lessonSelected.value = {
      number: -1,
      name: '',
      type: 'VIDEO',
      videoUrl: '',
   }
};

const lessonSelection = (lessonNumber) => {
   lessonSelected.value = chapterSelected.value.lessons.find(lesson => lesson.number == lessonNumber);
}

const logarithmicFunction = (x) => {
   //a function to mimic the amount of characters in the subtitle per window width size
   const result = 30*Math.log(0.01*x-3.83)-42.6;
   return result > 0 ? result : 0;
}

const descriptionSliced = () => {
   //slice the description by a amount depending on the window width size;
   const windowWidth = process.client ? window.innerWidth : 1488;
   const descriptionSize = Math.floor(logarithmicFunction(windowWidth));
   const ellipsis = descriptionSize >= chapterSelected.value.name.length ? '' : '...';
   return chapterSelected.value.name.slice(0, descriptionSize) + ellipsis;
}
</script>

<template>
   <div id="inner-body-course" class="spaced-body">
      <AppHeader />

      <div id="view-body-course">
         <div class="side-bar">
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
                  <div class="course-chapter-title">
                     <h1 class="red-font" style="white-space: nowrap;">{{ course.name }}</h1>
                     <div class="line" />
                     <h1>{{ descriptionSliced() }}</h1>
                  </div>
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

            <ChapterTest 
               v-else-if="!pending && !(lessonSelected.type == 'VIDEO')"
               :lessonNumber="+lessonSelected.number"
               :chapterNumber="+chapterSelected.number"
            />
         </div>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/course.css");
</style>
