<script setup>
const props = defineProps({
  history: Object
});

const { history } = props;

const weekDays = [
   { name: "Dom", value: 0, percentage: 0 },
   { name: "Seg", value: 0, percentage: 0 },
   { name: "Ter", value: 0, percentage: 0 },
   { name: "Qua", value: 0, percentage: 0 },
   { name: "Qui", value: 0, percentage: 0 },
   { name: "Sex", value: 0, percentage: 0 },
   { name: "Sab", value: 0, percentage: 0 },
];

let highestValue = 0;
history.forEach(hist => {
   if(hist.completed) {
      const index = new Date(hist.updatedAt).getDay();
      weekDays[index].value++;
      highestValue = weekDays[index].value > highestValue ? weekDays[index].value : highestValue;
      
      weekDays.forEach(day => {
         day.percentage = (day.value / highestValue) * 100;
      })
   }
})
</script>

<template>
   <div class="daily-conclusions-box shadow bordered">
      <h2>Conclusões Diárias</h2>

      <div class="daily-bars">
         <div class="daily-bar" v-for="day in weekDays">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner" :style="'height: ' + day.percentage + '%'">
                  <span class="white-font">{{ day.value }}</span>
               </div>
            </div>
            <span class="day-name">{{ day.name }}</span>
         </div>
      </div>
   </div>
</template>

<style scoped>
.daily-conclusions-box {
   width: 100%;
   padding: 25px;
   background-color: #ffffff;

   h2 {
      margin-bottom: 20px;
   }
}

.daily-bars {
   display: flex;
   justify-content: space-between;
}

.daily-bar {
   display: flex;
   max-width: fit-content;
   align-items: center;
   flex-direction: column;
   gap: 10px;
}

.bar-outer {
   display: flex;
   align-items: flex-end;
   height: 150px;
   width: 35px;
   border-radius: 10px;
   overflow: hidden;
}

.bar-inner {
   width: 100%;
   display: flex;
   justify-content: center;
   align-items: center;
   border-radius: 10px;

   span {
      writing-mode: vertical-rl;
   }
}

@media screen and (max-width: 390px) {
   .bar-outer {
      width: 30px;
   }

   .day-name {
      font-size: 0px;
   }
   
   .day-name::first-letter {
      font-size: 16px;
   }
}

@media screen and (max-width: 330px) {
   .bar-outer {
      width: 25px;
   }
}
</style>
