//= require js-cookie/src/js.cookie
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
  for (const i in Abraham.incompleteTours) {
    var tour_did_run = Abraham.tours[Abraham.incompleteTours[i]].checkAndStart();
    if(tour_did_run){ break; };
  };
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
