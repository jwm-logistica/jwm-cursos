<script setup>
const { lessonNumber, chapterNumber } = defineProps(["lessonNumber", "chapterNumber"]);

const currentIndex = ref(0);
const { questionsFromLesson } = await $fetch('/api/questions', { params: { id: lessonNumber, chapterNumber: chapterNumber } });

const questions = ref(questionsFromLesson.questions?.map((question) => {
   const alternatives = question.alternatives?.map((alt, index) => {
      return {
         ...alt,
         selected: false,
         index
      }
   })
   return {
      ...question,
      alternatives
   }
}))

const submitButton = ref("");
const backButton = ref('');
const currentAlternative = ref({});
const bodyAdditionalStyle = ref("");

const changeButtonStyle = (buttonRef, bgColor, color, cursor, disabled=false) => {
   buttonRef.value.style.backgroundColor = bgColor;
   buttonRef.value.style.color = color;
   buttonRef.value.style.cursor = cursor;
   buttonRef.value.disabled = disabled;
}

const onChange = (alternative) => {
   changeButtonStyle(submitButton, "#e31c24", "#fbfbfb", "pointer", false);

   currentAlternative.value = alternative;
};

const onSubmit = (forward=true) => {
   if(forward && currentIndex.value == questions.value.length -1) {
      //if the user finished the test, then change the body style and show the results
      bodyAdditionalStyle.value = "opacity: 20%; cursor: default; pointer-events: none;"
   } else if(!forward && currentIndex.value == questions.value.length -1 && bodyAdditionalStyle.value != '') {
      //if the user finished the test but pressed retry then resets everything
      questions.value = questions.value.map((question) => {
         return {
            ...question,
            alternatives: question.alternatives.map(alt => {
               return {
                  ...alt,
                  selected: false,
               }
            })
         }
      })

      //reset body style
      bodyAdditionalStyle.value = "";

      //go to the first question
      currentIndex.value = 0;

      //remove any checked alternative (just in case client side bug)
      var alts = document.getElementsByName('alternative');
      alts.forEach(alt => alt.checked = false);

      //then reset the submit button style (disable it)
      changeButtonStyle(submitButton, "#f4e6e6", "#fbfbfb", "default", true);

      //stop the function to prevent any unwanted logic bugs
      return;
   } else {
      bodyAdditionalStyle.value = "";
   }

   //reset all alternatives selected properties to false excepts for the new selected
   questions.value[currentIndex.value].alternatives = questions.value[currentIndex.value].alternatives.map(alt => {
      return {
         ...alt,
         selected: alt.index === currentAlternative.value?.index,
      }
   })

   if(forward && currentIndex.value < questions.value.length - 1) {
      //moving to the next question
      currentIndex.value += 1;
   } else if (!forward && currentIndex.value >= 1) {
      //going back one question
      currentIndex.value -= 1;
   }

   if(currentIndex.value > 0) {
      changeButtonStyle(backButton, "#f2f2f2", "#e31c24", "pointer", false);  
   } else {
      changeButtonStyle(backButton, "#f4e6e6", "#fbfbfb", "default", true); 
   }

   const alternatives = questions.value[currentIndex.value].alternatives
   const altIndex = alternatives.findIndex(alt => alt.selected);
   if(altIndex != -1) {
      //if one of the alternatives is already selected, then enable the button
      changeButtonStyle(submitButton, "#e31c24", "#fbfbfb", "pointer", false);

      //update the current alternative
      currentAlternative.value = alternatives[altIndex];
   } else {
      //if none of the alternatives of the new question is selected then disable the submit button
      changeButtonStyle(submitButton, "#f4e6e6", "#fbfbfb", "default", true);

      //reset the current alternative to the new question
      currentAlternative.value = {};

      var alts = document.getElementsByName('alternative');
      alts.forEach(alt => alt.checked = false);
   }
}

const getResults = () => {
   const amountOfQuestions = questions.value.length;

   let correctAnswersCount = 0;
   questions.value.forEach(question => {
      question.alternatives.forEach(alt => {
         if(alt.selected && alt.correctAnswer) {
            console.log(alt);
            correctAnswersCount+=1;
         }
      })
   })

   return {
      correct: correctAnswersCount, 
      total: amountOfQuestions, 
      percentage: ((correctAnswersCount/amountOfQuestions)*100).toFixed(1)
   };
}
</script>

<template>
   <div id="chapter-test-body">
      <div class="question-body" :style="bodyAdditionalStyle">
         <p>{{ currentIndex + 1 + ' - ' + questions[currentIndex].text }}</p>
         <div class="shadow bordered alternative-box" v-for="alternative in questions[currentIndex].alternatives">
            <label @change="() => onChange(alternative)">
               <input type="radio" name="alternative" :checked="alternative.selected"/>
               <span>{{ alternative.text }}</span>
            </label>
         </div>
      </div>
      <h2 v-if="bodyAdditionalStyle != ''">Resultados</h2>
      <p v-if="bodyAdditionalStyle != ''">{{ getResults().percentage >= 75 ? 'Parabéns' : 'Continue praticando' }}, você acertou {{ getResults().correct }} das {{ getResults().total }} questões do teste ({{ getResults().percentage }}%)</p>
      <div class="button-box">
         <button 
            ref="backButton" 
            disabled="true" 
            @click="() => onSubmit(false)"
         >
            {{ bodyAdditionalStyle != '' ? "REPETIR TESTE" : "VOLTAR"}}
         </button>
         <button
            class="submit-button button-main"
            ref="submitButton"
            disabled="true"
            @click="() => onSubmit(true)"
         >
            {{ currentIndex == questions.length - 1 ? "FINALIZAR" : "AVANÇAR" }}
         </button>
      </div>
   </div>
</template>

<style scoped>
#chapter-test-body {
   display: flex;
   flex-direction: column;
   align-items: flex-start;
   gap: 18px;
   margin-top: 15px;
}

.question-body {
   display: flex;
   flex-direction: column;
   align-items: flex-start;
   gap: 18px;
}
.alternative-box {
   display: flex;
   align-items: center;
   width: 100%;
}

label {
   display: flex;
   align-items: center;
   width: 100%;   
   gap: 14px;
   cursor: pointer;
   padding: 14px;
}

input {
   appearance: none;
   min-width: 18px;
   min-height: 18px;
   padding: 0px;
   border-radius: 50%;
   border: 1px solid #414141;
   box-shadow: none;
   cursor: pointer;
}

input:checked {
   background: radial-gradient(circle, #000 50%, #fbfbfb 60%);
}

.button-box {
   margin-top: 20px;
   display: flex;
   width: 100%;
   justify-content: space-between;

   button {
      background-color: #f4e6e6;
      color: #fbfbfb;
      width: fit-content;
      padding: 16px 20px 16px 20px;
      cursor: default;
   }
}

.submit-button {
   background-color: #f4e6e6;
   cursor: default;
}
</style>
