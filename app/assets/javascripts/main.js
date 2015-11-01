var pageloaded = function () {
  $(".habit-create-form").hide();

  $(".habit-create-button").on('click', function () {
    var $form = $(this).siblings(".habit-create-form");
    $form.slideToggle();
    $(".habit-create-form").not($form).slideUp();
    $(".habit-create-button").not(this).text("Show Habit Form");
    $(this).text(function(i, text) {
      return text == "Hide Habit Form" ? "Show Habit Form" : "Hide Habit Form";
    })
  });
};

$(document).ready(pageloaded);
$(document).on('page:load', pageloaded);

var timezoneset = function() {
  $('#detected_time_zone').set_timezone({format: 'city'});
};

$(document).ready(timezoneset);
$(document).on('page:load', timezoneset);
