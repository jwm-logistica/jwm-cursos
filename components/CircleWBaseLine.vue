<script setup>
</script>

<template>
   <div class="circle-base-line">
      <div class="base-line" />
      <div ref="circleRef" class="border-circle" />
   </div>
</template>

<style scoped>
.circle-base-line {
   display: flex;
   flex-direction: column;
   align-items: center;
}
.border-circle {
   width: 18px;
   height: 18px;
   border: 1px solid #dbdbdb;
   border-radius: 50%;
}

.active {
   border: 2px solid #414141;
}

.base-line {
   width: 1px;
   background-color: #dbdbdb;
   height: 15px;
}
</style>
