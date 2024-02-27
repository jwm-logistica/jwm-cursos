<script setup>
const props = defineProps({
  history: Object
});

const { history } = props;

const remappedHistory = remapHistory();

function remapHistory() {
   //helper function to format date as "dd/MMM/yyyy"
   const formatDate = (date) => {
      const options = { day: '2-digit', month: 'short', year: 'numeric', timeZone: 'UTC' };
      return date.toLocaleDateString('pt-BR', options).replace(/ de /g, '/').replace(/\./g, '')
   };

   //create a map to group lessons by courseId and date
   const historyMap = new Map();
   history.forEach((historyObj) => {
      const courseId = historyObj.lesson.chapter.course.id;
      const date = formatDate(new Date(historyObj.createdAt));
      const lessonKey = `${courseId}-${date}`;

      if (!historyMap.has(lessonKey)) {
         historyMap.set(lessonKey, {
            completed: historyObj.completed,
            courseId: courseId,
            course: historyObj.lesson.chapter.course.name,
            date: date,
            lessons: [],
         });
      }

      historyMap.get(lessonKey).lessons.push({
         chapter: historyObj.lesson.chapter.name,
         name: historyObj.lesson.name,
         type: historyObj.lesson.type,
         duration: historyObj.lesson.durationMinutes,
      });
   });

   //convert the map into an array and sort by date in descending order
   return Array.from(historyMap.values()).sort((a, b) => 
      new Date(b.date.split('/').reverse().join('-')) - new Date(a.date.split('/').reverse().join('-'))
   );
}
</script>

<template>
   <div class="history-box shadow bordered">
      <h2>Histórico</h2>
      <div class="day-lessons">
         <div v-for="data in remappedHistory">
            <div class="course-name-date">
               <h3>{{ data.course }}</h3>
               <h3>{{ data.date }}</h3>
            </div>
            <div class="lessons">
               <div class="lesson-done" v-for="lesson in data.lessons">
                  <CircleWBaseLine />
                  <div class="chapter-lesson-name">
                     <span class="lighter chapter-name">
                        {{ lesson.chapter }}
                     </span>
                     <span class="lighter">
                        {{' - ' + lesson.name }}
                     </span>
                  </div>
                  <span class="lighter">{{
                     !lesson.duration ? null : lesson.duration + "min"
                  }}</span>
               </div>
            </div>
         </div>
      </div>
   </div>
</template>

<style scoped>
.history-box {
   max-width: 430px;
   width: 100%;
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

.chapter-lesson-name {
   max-width: 290px;
   display: inline-block;
   span {
      line-height: normal !important;
      vertical-align: bottom;
   }
}

.chapter-name {
   max-width: 50%;
   white-space: nowrap;
   text-overflow: ellipsis;
   overflow: hidden;
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
