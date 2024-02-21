<script setup>
const route = useRoute();
const { id } = route.params;
const userId = route.query.userId;

const { chapters } = await $fetch('/api/chapters', { params: { id: id }});
const { course } = await $fetch('/api/course', { params: { id: id, userId: userId }});

const lessonSelected = ref({
   name: "",
   isVideo: true,
   videoUrl: "",
});

const windowWidth = process.client ? window.innerWidth : 1488;
const descriptionSize = Math.floor(windowWidth / 51.31);

const chapterSelected = ref({
   name: chapters[0].name,
   title: chapters[0].title,
   description: chapters[0].description
});
</script>

<template>
   <div id="inner-body-course" class="spaced-body">
      <AppHeader />

      <div id="view-body-course">
         <div class="side-bar">
            <div class="back-and-progress">
               <NuxtLink to="/courses" class="red-font">Voltar</NuxtLink>
               <ProgressBar />
               <span class="lighter">8/9</span>
            </div>
            <CourseChapter
               :chapter="chapter"
               v-for="chapter in chapters"
               @lessonSelection="value => (lessonSelected = value)"
               @chaterSelection="value => (chapterSelected = value)"
            />
         </div>

         <div class="chapter-view">
            <div class="chapter-text">
               <div>
                  <div class="course-chapter-title">
                     <h1 class="red-font" style="white-space: nowrap;">{{ course.name }}</h1>
                     <div class="line" />
                     <h1>{{ chapterSelected.name.slice(0, descriptionSize) + '...' }}</h1>
                  </div>
                  <h2> {{ chapterSelected.title }}</h2>
               </div>

               <p>{{ chapterSelected.description }} </p>
            </div>

            <div class="chapter-video-box" v-if="lessonSelected.isVideo">
               <h2>{{ lessonSelected.name }}</h2>
               <div class="chapter-video bordered shadow" />
            </div>

            <ChapterTest v-if="!lessonSelected.isVideo" />
         </div>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/course.css");
</style>
