<script setup>
const route = useRoute();
const { lessonNumber, chapterNumber } = defineProps(["lessonNumber", "chapterNumber"]);
const emit = defineEmits(["nextLesson"]);

const currentIndex = ref(0);
const { questionsFromLesson } = await $fetch('/api/questions', { params: { id: lessonNumber, chapterNumber: chapterNumber } }).catch(e=> console.log(e))

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
const results = ref({
   finished: false,
   correct: 0,
   total: questions.value.length,
   percentage: 0,
})
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

   //reset all alternatives selected properties to false excepts for the new selected
   questions.value[currentIndex.value].alternatives = questions.value[currentIndex.value].alternatives.map(alt => {
      return {
         ...alt,
         selected: alt.index === currentAlternative.value?.index,
      }
   })
};

const updateResults = async() => {
   const amountOfQuestions = questions.value.length;

   let correctAnswersCount = 0;
   questions.value.forEach(question => {
      question.alternatives.forEach(alt => {
         if(alt.selected && alt.correctAnswer) {
            correctAnswersCount+=1;
         }
      })
   })

   results.value = {
      finished: true,
      correct: correctAnswersCount, 
      total: amountOfQuestions, 
      percentage: ((correctAnswersCount/amountOfQuestions)*100).toFixed(1)
   };

   //get all the test results for the course and update courseOnUsers average
   const courseId = route.params.id;
   const { testResultsByCourse } = await $fetch('/api/results-by-course', { 
      params: { 
         userId: +route.query.userId, 
         courseId: +courseId
      }
   });

   //making sure that the results are upToDate with the current test result
   let testResultFound = false
   let mappedResultsByCourse = []
   mappedResultsByCourse = testResultsByCourse.map((result) => {
      if(result.lessonNumber == lessonNumber) {
         testResultFound = true;
         //found the corresponding test

         return {
            ...result,
            correctAnswers: correctAnswersCount
         }
      } else {
         return result
      }
   })

   if(!testResultFound) {
      //case it this test was not done yet
      mappedResultsByCourse.push({
         correctAnswers: correctAnswersCount,
         questionsAmount: amountOfQuestions,
      })
   }

   const { data } = useNuxtData('user-course-chapters');
   const chapters = data.value.chapters;
   
   let totalAmountOfTests = 0;
   chapters.forEach(chapter => {
      const testsAmount = chapter.lessons.reduce((a, c) => c.type == 'TEST' ? a+1 : a+0, 0);
      totalAmountOfTests += testsAmount;
   })

   const sum = mappedResultsByCourse.reduce((acc, current) => acc + (current.correctAnswers / current.questionsAmount), 0);
   const average = Math.ceil((sum / totalAmountOfTests)*100);

   await $fetch('/api/progress', {
      method: 'PUT',
      body: {
         userId: +route.query.userId,
         courseId: +courseId,
         average: average,
         progress: null, //progress will not be changed
      }
   })

   await $fetch('/api/results', {
      method: 'POST',
      body: {
         userId: +route.query.userId,
         lessonNumber: lessonNumber,
         chapterNumber: chapterNumber,
         correctAnswers: correctAnswersCount,
      }
   })

   //update user history
   await $fetch('/api/history', {
      method: 'POST',
      body: {
         userId: +route.query.userId,
         lessonNumber: lessonNumber,
         chapterNumber: chapterNumber,
         completed: true,
      }
   })
}
 
const onSubmit = (forward=true) => {
   if(forward && currentIndex.value == questions.value.length -1) {
      if(bodyAdditionalStyle.value) {
         //if the addtional style of the body is already set and the user pressed "finish" again...
         return emit("nextLesson");
      }
      //if the user finished the test, then change the body style and show the results
      bodyAdditionalStyle.value = "opacity: 20%; cursor: default; pointer-events: none;"
      updateResults();
   } else if(!forward && currentIndex.value == questions.value.length -1 && results.value.finished) {
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
      <h2 v-if="results.finished">Resultados</h2>
      <p v-if="results.finished">{{ results.percentage >= 75 ? 'Parabéns' : 'Continue praticando' }}, você acertou {{ results.correct }} das {{ results.total }} questões do teste ({{ results.percentage }}%)</p>
      <div class="button-box">
         <button 
            ref="backButton" 
            disabled="true" 
            @click="() => onSubmit(false)"
         >
            {{ results.finished ? "REPETIR TESTE" : "VOLTAR"}}
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
   transition: all 0.5s ease;
}

label:active {
   transform-origin: center;
   transform: scale(1.005);
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
