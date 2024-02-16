<script setup>
const buttonRef = ref("");

const onChange = () => {
   buttonRef.value.style.backgroundColor = "#e31c24";
   buttonRef.value.style.cursor = "pointer";
   buttonRef.value.disabled = false;
};
</script>

<template>
   <form id="chapter-test-body">
      <div class="shadow bordered question-box">
         <label @change="onChange">
            <input type="radio" name="question" />
            <span>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vitae
               purus nisi. Aenean iaculis cursus elit et ultrices. Etiam nunc
               nulla, pharetra varius porta eu, pellentesque eget nulla.
            </span>
         </label>
      </div>
      <div class="shadow bordered question-box">
         <label @change="onChange">
            <input type="radio" name="question" />
            <span>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vitae
               purus nisi. Aenean iaculis cursus elit et ultrices. Etiam nunc
               nulla, pharetra varius porta eu, pellentesque eget nulla.
            </span>
         </label>
      </div>
      <div class="shadow bordered question-box">
         <label @change="onChange">
            <input type="radio" name="question" />
            <span>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vitae
               purus nisi. Aenean iaculis cursus elit et ultrices. Etiam nunc
               nulla, pharetra varius porta eu, pellentesque eget nulla.
            </span>
         </label>
      </div>
      <button
         type="submit"
         class="submitButton button-main"
         ref="buttonRef"
         disabled="true"
         @click="console.log('clicked')"
      >
         AVANÇAR
      </button>
   </form>
</template>

<style scoped>
#chapter-test-body {
   display: flex;
   flex-direction: column;
   align-items: flex-end;
   gap: 18px;
}
.question-box {
   padding: 14px;
   display: flex;
   align-items: center;
}

label {
   display: flex;
   align-items: center;
   gap: 14px;
   cursor: pointer;
}

input {
   appearance: none;
   width: 18px;
   height: 18px;
   padding: 0px;
   border-radius: 50%;
   border: 1px solid #414141;
   box-shadow: none;
}

input:checked {
   background: radial-gradient(circle, #000 50%, #fbfbfb 60%);
}

.submitButton {
   margin-top: 20px;
   width: fit-content;
   background-color: #f4e6e6;
   padding: 16px 20px 16px 20px;
   cursor: default;
}
</style>
