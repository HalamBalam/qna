$(document).on('turbolinks:load', function() {

  $('.question').on('click', '.comment-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('form#new-question-comment').removeClass('hidden');
  })

});
