$(document).on('turbolinks:load', function() {

  $('.question-subscribtion-actions').on('ajax:success', function(e) {
    let html = e.detail[0];
    $('.question-subscribtion-actions').html(html.body.innerHTML);
  })

});
