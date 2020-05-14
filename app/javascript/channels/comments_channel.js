import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  consumer.subscriptions.create("CommentsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      let comment = JSON.parse(data);
      let comments_path = '.' + comment.context + '-' + comment.commentable_id + ' .comments';

      if ($(comments_path).length != 0 ) {
        $(comments_path).append('<p>#' + comment.user + ': ' + comment.body + '</p>')
      }
    }
  });

})
