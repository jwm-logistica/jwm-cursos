<template>
   <div class="daily-conclusions-box shadow">
      <h2>Conclusões Diárias</h2>

      <div class="daily-bars">
         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Seg</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Ter</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Qua</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Qui</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Sex</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Sab</span>
         </div>

         <div class="daily-bar">
            <div class="bar-background bar-outer">
               <div class="red-background bar-inner">
                  <span>5</span>
               </div>
            </div>
            <span>Dom</span>
         </div>
      </div>
   </div>
</template>

<style>
.daily-conclusions-box {
   width: fit-content;
   padding: 25px;
   border-radius: 10px;

   h2 {
      margin-bottom: 20px;
   }
}

.daily-bars {
   display: flex;
   gap: 18px;
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
   height: 60%;
   display: flex;
   justify-content: center;
   align-items: center;
   border-radius: 10px;

   span {
      writing-mode: vertical-rl;
   }
}
</style>
