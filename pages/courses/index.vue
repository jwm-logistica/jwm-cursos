<script setup>
   const { signOut, data } = useAuth();
   if(!data.value.user.email) {
      await signOut({ callbackUrl: '/' });
   }
   const id = +data.value.user.email.split("-")[0];

   const statisticsIsSidebar = ref(false);
   const showStatistics = ref(false);

   const { courses } = await $fetch(`/api/courses?id=${encodeURIComponent(id)}`);
   const { history } = await $fetch(`/api/history?userId=${encodeURIComponent(id)}`)
   
   const getCoursesMatrix = () => {
      //mansory layout
      const coursesMatrix = [];

      let statisticsBoxWidth = 430;
      if(process.client) {
         if(statisticsIsSidebar) {
            //the statistics will not occupy any space
            statisticsBoxWidth = 0;
         } else {
            statisticsBoxWidth = document.getElementById('statistics-box').offsetWidth;
         }
      }
      
      const coursesBoxWidth = process.client ? window.innerWidth - (statisticsBoxWidth + 30 + 2*55) : 870; 
      //size of the client window - (size of the history + gap + page padding)
      
      const columns = Math.floor(coursesBoxWidth / 290); //coursesBoxWidth divided by course max-width (280) plus gap/2 (20/2)
      const rows = Math.ceil(courses.length / columns); //amount of rows depending on courses and columns amount
   
      for (let col = 0; col < columns; col++) {
         //the loop goes from each column and pushs all the rows with its courses to the coursesMatrix 
         //start each index with the column number, it is used to organize the courses from the top left to the bottom right
         let courseIndex = col; 
         const actualRows = [];
         for (let row = 0; row < rows; row++) {
            if (courseIndex < courses.length) {
               actualRows.push(courses[courseIndex]); //push the course to its row of the column
               courseIndex+=columns;
            }
         }
         coursesMatrix.push(actualRows); //push all the rows to the column
      }

      return coursesMatrix;
   }

   const statisticsBoxResponsivness = () => {
      const minWindowWidth = 800;
      if(window.innerWidth <= minWindowWidth) {
         statisticsIsSidebar.value = true;
      }
   } 

   process.client ? statisticsBoxResponsivness() : null;
</script>

<template>
   <div class="spaced-body">
      <AppHeader />

      <div id="view-body-courses">
         <div class="courses-view">
            <h1 class="red-font">MEUS CURSOS</h1>
            <!-- Client only to avoid hidration mismatch -->
            <ClientOnly>
               <div id="masonry-layout-courses">
                  <div class="masonry-column" v-for="columns in getCoursesMatrix()">
                     <Course v-for="course in columns" :course="course"/>
                  </div>
               </div>
            </ClientOnly>
         </div>

         <Transition name="side-right" appear>
            <div class="statistics-box" id="statistics-box" v-show="showStatistics">
               <DailyConclusions :history="history" />
               <History :history="history" />
            </div>
         </Transition>
         <button class="sidebar-button shadow" @click="() => showStatistics = !showStatistics"/>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/courses.css");
</style>
