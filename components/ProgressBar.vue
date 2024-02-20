<script setup>
const { progress } = defineProps(["progress"]);

let actualProgress = 0;
if(progress && progress != Infinity) {
   actualProgress = progress;
} else if(progress == Infinity) {
   actualProgress = 100;
}
</script>

<template>
   <div class="progress-bar bar-background">
      <div class="red-background" :style="'width:'+actualProgress+'%'"/>
   </div>
</template>

<style scoped>
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
