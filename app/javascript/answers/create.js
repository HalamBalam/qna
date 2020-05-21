$(document).on('turbolinks:load', function() {

  $('form.new-answer').on('ajax:success', function(e) {
    var answer = e.detail[0];

    $('.new-answer .field input').each(function(index, item) {
      item.value = '';
    });
  })
    
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    })

});
