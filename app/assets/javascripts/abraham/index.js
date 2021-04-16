//= require js-cookie/src/js.cookie
//= require shepherd.js/dist/js/shepherd

var abrahamReady = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

document.addEventListener('turbolinks:before-cache', function() {
  // Remove visible product tours
  document.querySelectorAll(".shepherd-element").forEach(function(el) { el.remove() });
});
