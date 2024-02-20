<script setup>
const historyData = [
   {
      course: "Certificado OEA",
      date: "10/Fev/2024",
      lessons: [
         {
            chapter: "Procedimentos e Processos",
            name: "Teste do capítulo",
            duration: 0,
         },
      ],
   },
   {
      course: "Certificado OEA",
      date: "09/Fev/2024",
      lessons: [
         {
            chapter: "Procedimentos e Processos",
            name: "Vídeo Aula 1",
            duration: 35,
         },
         {
            chapter: "Procedimentos e Processos",
            name: "Vídeo Aula 2",
            duration: 25,
         },
      ],
   },
];
</script>

<template>
   <div class="history-box shadow bordered">
      <h2>Histórico</h2>
      <div class="day-lessons">
         <div v-for="data in historyData">
            <div class="course-name-date">
               <h3>{{ data.course }}</h3>
               <h3>{{ data.date }}</h3>
            </div>
            <div class="lessons">
               <div class="lesson-done" v-for="lesson in data.lessons">
                  <CircleWBaseLine />
                  <p class="lighter">
                     {{ lesson.chapter }} - {{ lesson.name }}
                  </p>
                  <span class="lighter">{{
                     lesson.duration == 0 ? null : lesson.duration + "min"
                  }}</span>
               </div>
            </div>
         </div>
      </div>
   </div>
</template>

<style scoped>
.history-box {
   width: max-content;
   padding: 25px;
   display: flex;
   flex-direction: column;
   gap: 20px;
   background-color: #ffffff;

   h3 {
      font-weight: normal;
   }
}

.day-lessons {
   display: flex;
   flex-direction: column;
   gap: 15px;
}

.lessons {
   display: flex;
   flex-direction: column;
}

.course-name-date {
   display: flex;
   align-items: center;
   justify-content: space-between;
   margin-bottom: 5px;
}

.lesson-done {
   display: flex;
   align-items: flex-end;
   gap: 10px;

   p,
   span {
      display: inline-block;
      line-height: 17px;
   }
}
</style>
