<script setup>
const { id } = useRoute().params;
const chapters = [
   {
      title: "Capítulo 1 - Processos e Procedimentos",
      lessons: [
         { done: true, name: "Vídeo Aula 1", isVideo: true },
         { done: false, name: "Vídeo Aula 2", isVideo: true },
         { done: false, name: "Teste do capítulo", isVideo: false },
      ],
   },
   {
      title: "Capítulo 2 - Processos e Procedimentos",
      lessons: [
         { done: true, name: "Vídeo Aula 1", isVideo: true },
         { done: false, name: "Teste do capítulo", isVideo: false },
      ],
   },
   {
      title: "Capítulo 3 - Processos e Procedimentos",
      lessons: [],
   },
];
</script>

<template>
   <div id="inner-body-course" class="spaced-body">
      <AppHeader />

      <div id="view-body-course">
         <div class="side-bar">
            <div class="back-and-progress">
               <NuxtLink to="/courses" class="red-font">Voltar</NuxtLink>
               <ProgressBar />
               <span class="lighter">8/9</span>
            </div>
            <div v-for="chapter in chapters">
               <CourseChapter :chapter="chapter" />
            </div>
         </div>

         <div class="chapter-view">
            <div class="chapter-text">
               <div>
                  <div class="course-chapter-title">
                     <h1 class="red-font">CURSO: [{{ id }}]</h1>
                     <div class="line" />
                     <h1>PROCEDIMENTOS E PROCESSOS</h1>
                  </div>

                  <h2>
                     “Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                     Integer lacinia nunc ac turpis egesta”
                  </h2>
               </div>
               <p>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                  Integer lacinia nunc ac turpis egestas suscipit. Morbi laoreet
                  velit dolor, sed pulvinar nisl vehicula sagittis. Ut vitae
                  purus nisi. Aenean iaculis cursus elit et ultrices. Etiam nunc
                  nulla, pharetra varius porta eu, pellentesque eget nulla.
                  Pellentesque sit amet aliquet dui. Nam consectetur ex volutpat
                  augue laoreet, non dignissim ex imperdiet. Vestibulum interdum
                  sagittis convallis. In sit amet viverra eros, eget mattis
                  dolor. Sed at lacus condimentum nulla mattis pharetra. Nam
                  felis tortor, facilisis quis nunc sit amet, tempor dignissim
                  augue. Vivamus pretium, nisl ut auctor lobortis, arcu turpis
                  cursus felis, sit amet egestas ex est a leo. Cras tincidunt
                  tempus nunc ac mattis. Sed sed tristique ante. In lacinia in
                  mi a pellentesque. Vestibulum a felis justo. Praesent magna
                  lorem, luctus blandit sem sed, blandit dictum lectus.
                  Vestibulum porta sapien sit amet tellus finibus, et eleifend
                  velit sollicitudin. Phasellus sed enim id nibh congue cursus
                  non fermentum purus. Proin lobortis, diam eu porttitor
                  pharetra, augue ipsum accumsan nulla, non viverra massa ligula
                  id augue. Donec varius eros eget dui elementum, in congue
                  velit tristique. Etiam non fringilla justo. Vivamus egestas
                  neque id placerat fermentum. Integer mollis vestibulum metus,
                  et rutrum libero. Aenean eros tellus, porttitor vel ultrices
                  vitae, volutpat sit amet nunc. Curabitur semper magna ligula,
                  ut aliquam dui fringilla fermentum. Nam in erat at dolor
                  tempus tincidunt. Morbi mi enim, molestie id ultricies semper,
                  sollicitudin eu quam. Etiam consequat, velit sed sodales
                  tempus, orci quam sodales massa, ac euismod dolor mauris sit
                  amet ex. Suspendisse eleifend tristique dui ut pharetra. In
                  facilisis elit nec aliquam condimentum. Aliquam elementum
                  dolor a elit lobortis, ut pretium urna vulputate.
               </p>
            </div>
            <div class="chapter-video-box">
               <h2>Vídeo aula []:</h2>
               <div class="chapter-video bordered shadow" />
            </div>
         </div>
      </div>
   </div>
</template>

<style scoped>
@import url("~/assets/css/course.css");
</style>
