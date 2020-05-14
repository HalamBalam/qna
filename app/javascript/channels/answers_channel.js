import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if ($('.answers').length != 0) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        let answer = JSON.parse(data);

        let xhr = new XMLHttpRequest();
        xhr.open('GET', answer.path, false);
        xhr.send();

        if (xhr.status == 200) {
          $('.answers').append(xhr.responseText);
        }

      }
    });
  }
})
