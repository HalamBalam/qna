$(document).on('turbolinks:load', function() {

  $('.questions-list').on('click', '.comment-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    let questionId = $(this).data('questionId');
    $('form#new-question-comment-' + questionId).removeClass('hidden');
  })

});
