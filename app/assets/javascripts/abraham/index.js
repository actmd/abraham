//= require jquery
//= require js-cookie/src/js.cookie
//= require shepherd.js/dist/js/shepherd

$(document).on('turbolinks:before-cache', function() {
    // Remove visible product tours
    $(".shepherd-step").remove();
});
