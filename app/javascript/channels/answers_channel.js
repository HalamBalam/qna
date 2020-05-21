import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if ($('.answers').length == 0) {
    return;
  }
   
  consumer.subscriptions.create({ channel: "AnswersChannel" }, {
    connected() {
      // Called when the subscription is ready for use on the server
      this.perform('follow', { question_id: gon.question_id });
    },

    received(data) {
      let answer = JSON.parse(data);

      if (gon.current_user == answer.user) {
        return;
      }

      $('.answers').append(answer.html);
      
      if (!gon.current_user || gon.current_user != answer.author_of_question) {
        $('.answers .answer-' + answer.id + ' .mark-as-best-link').remove();
      }

      if (!gon.current_user) {
        $('.answers .answer-' + answer.id + ' .answer-vote-actions').remove();
        $('.answers .answer-' + answer.id + ' .new-answer-comment').remove();
      }
    }
  });
  
})
