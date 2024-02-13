<template>
   <NuxtLink to="/courses/1">
      <div class="course-box shadow bordered">
         <img src="/oea-logo.png" width="100" />

         <div>
            <h2>Certificado OEA</h2>
            <p class="lighter">
               Nullam aliquam tincidunt ante, id dignissim sem varius eget.
               Etiam vitae arcu leo. Aliquam volutpat sem non mi condimentum...
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
