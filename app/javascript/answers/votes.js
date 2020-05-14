$(document).on('turbolinks:load', function() {

  $('.answer-vote-actions').on('ajax:success', function(e) {
    var vote = e.detail[0];
    var answerId = document.activeElement.dataset.answerId;

    var rating = $('.answer-' + answerId + ' > .answer-rating > p')[0].textContent;
    rating = Number.parseInt(rating.slice(8));

    if (Array.isArray(vote)) {
      $('.answer-' + answerId + ' > .answer-vote-actions > .answer-vote').removeClass('hidden');
      $('.answer-' + answerId + ' > .answer-vote-actions > .answer-re-vote').detach();
      rating -= vote[0];
    } else {
      $('.answer-' + answerId + ' > .answer-vote-actions > .answer-vote').addClass('hidden');  
      $('.answer-' + answerId + ' > .answer-vote-actions')
      .append('<a class="answer-re-vote" data-answer-id="' + answerId + '" data-remote="true" rel="nofollow" data-method="delete" href="/votes/' + vote.id + '">re-vote</a>');
      rating += vote.rating;
    }

    $('.answer-' + answerId + ' > .answer-rating > p')[0].textContent = "Rating: " + rating;    
  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    })

});
