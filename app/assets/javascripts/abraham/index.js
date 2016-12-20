//= require jquery
//= require jquery_ujs
//= require js-cookie
//= require tether
//= require shepherd.js.js

$(document).on('turbolinks:before-cache', function() {
    // Remove visible product tours
    $(".shepherd-step").remove();
});
