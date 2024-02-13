<template>
   <div class="spaced-body">
      <AppHeader />

      <div id="view-body-courses">
         <div class="courses-box">
            <h1 class="red-font">MEUS CURSOS</h1>
            <Course />
         </div>

         <div class="statistics-box">
            <DailyConclusions />
            <History />
         </div>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/courses.css");
</style>
