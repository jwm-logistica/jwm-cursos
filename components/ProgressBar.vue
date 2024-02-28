<script setup>
const props = defineProps({
  progress: Number
});

const currentProgress = ref(0);

watch(() => props.progress, (newProgress) => {
   if(newProgress && newProgress != Infinity) {
      currentProgress.value = newProgress;
   } else if(newProgress == Infinity) {
      currentProgress.value = 100;
   }
}, { deep: true, immediate: true })
</script>

<template>
   <div class="progress-bar bar-background">
      <div class="red-background" :style="'transition: all 2s ease; width:'+currentProgress+'%'"/>
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
