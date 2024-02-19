<script setup>
   const { course } = defineProps(["course"]);
</script>

<template>
   <NuxtLink to="/courses/1">
      <div class="course-box shadow bordered">
         <img src="/oea-logo.png" width="100" />

         <div class="course-name-description">
            <h2>{{course.name}}</h2>
            <p class="lighter description">
               {{course.description.slice(0, 180) + '...'}}
            </p>
         </div>

         <div class="progress-text">
            <span>Progresso:</span>
            <span class="lighter">8/9</span>
         </div>

         <ProgressBar />
      </div>
   </NuxtLink>
</template>

<style scoped>
.course-box {
   max-width: 300px;
   padding: 25px;
   display: flex;
   flex-direction: column;
   gap: 20px;
   background-color: white;

   p {
      font-weight: lighter;
   }
}

.course-name-description {
   max-height: 150px;
}

.progress-text {
   display: flex;
   flex-direction: column;
}

.progress-bar {
   width: 100%;
   padding: 4px;
   border-radius: 6.5px;

   div {
      width: 90%;
      height: 5px;
      border-radius: 2.5px;
   }
}
</style>
