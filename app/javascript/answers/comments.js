$(document).on('turbolinks:load', function() {

  $('.answers').on('click', '.comment-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#new-answer-comment-' + answerId).removeClass('hidden');
  })

});
