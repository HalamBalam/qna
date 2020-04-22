$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('form#edit-question').removeClass('hidden');
  })

  $('.question-vote-actions').on('ajax:success', function(e) {
    var vote = e.detail[0];

    var rating = $('.question-rating > p')[0].textContent;
    rating = Number.parseInt(rating.slice(8));

    if (Array.isArray(vote)) {
      $('.question-vote').removeClass('hidden');
      $('.question-re-vote').detach();
      rating -= vote[0];
    } else {
      $('.question-vote').addClass('hidden');  
      $('.question-vote-actions')
      .append('<a class="question-re-vote" data-remote="true" rel="nofollow" data-method="delete" href="/votes/' + vote.id + '">re-vote</a>');
      rating += vote.rating;
    }
    
    $('.question-rating > p')[0].textContent = "Rating: " + rating;
  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>');
      })
    })

});
