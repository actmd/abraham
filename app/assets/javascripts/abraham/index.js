//= require js.cookie
//= require shepherd.min
//= require floating-ui.core.umd
//= require floating-ui.dom.umd

var Abraham = new Object();

Abraham.tours = {};
Abraham.incompleteTours = [];
Abraham.startTour = function (tourName) {
  if (!Shepherd.activeTour) {
    Abraham.tours[tourName].start();
  }
};
Abraham.startNextIncompleteTour = function () {
  if (Abraham.incompleteTours.length) {
    Abraham.tours[Abraham.incompleteTours[0]].checkAndStart();
  }
};

document.addEventListener('DOMContentLoaded', Abraham.startNextIncompleteTour);
document.addEventListener('turbolinks:load', Abraham.startNextIncompleteTour);

document.addEventListener('turbolinks:before-cache', function () {
  document.querySelectorAll('.shepherd-element').forEach(function (el) { el.remove(); });
  var activeTourScript = document.querySelector('#tour-guiado');
  if (activeTourScript) {
    activeTourScript.remove();
  }
  Abraham.tours = {};
  Abraham.incompleteTours = [];
});
