//= require js-cookie/dist/js.cookie
//= require shepherd.js/dist/js/shepherd

var Abraham = new Object();

Abraham.tours = {};
Abraham.incompleteTours = [];
Abraham.startTour = function(tourName) {
  if (!Shepherd.activeTour) {
  	Abraham.tours[tourName].start();
  }
};
Abraham.startNextIncompleteTour = function() {
  if (Abraham.incompleteTours.length) {
  	Abraham.tours[Abraham.incompleteTours[0]].checkAndStart();
  }
};

document.addEventListener("DOMContentLoaded", Abraham.startNextIncompleteTour);
document.addEventListener("turbolinks:load", Abraham.startNextIncompleteTour);

document.addEventListener('turbolinks:before-cache', function() {
  // Remove visible product tours
  document.querySelectorAll(".shepherd-element").forEach(function(el) { el.remove() });
  // Clear Abraham data
  Abraham.tours = {};
  Abraham.incompleteTours = [];
});
