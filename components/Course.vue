<script setup>
   const { course } = defineProps(["course"]);
   const courseDescription = course.description.length > 250 ? course.description.slice(0, 250) + '...' : course.description;
</script>

<template>
   <NuxtLink :to="'/courses/'+course.id+'?userId='+encodeURIComponent(course.userId)">
      <div class="course-box shadow bordered">
         <NuxtImg class="course-image" :src="course.imageUrl" height="70" :alt="'Logo do curso'+course.name" v-if="course.imageUrl"/>

         <div class="course-name-description">
            <h2>{{course.name}}</h2>
            <p class="lighter description">
               {{courseDescription}} 
            </p>
         </div>

         <div class="progress-text">
            <span>Progresso:</span>
            <span class="lighter">{{ course.progress + '/' + course.chaptersAmount }}</span>
         </div>

         <ProgressBar :progress="(course.progress / course.chaptersAmount) * 100"/>
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

.course-image {
   object-fit: contain;
   width: fit-content;
   border-radius: 10px;
}

.course-name-description {
   max-height: max-content;
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
