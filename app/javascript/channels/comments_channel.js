import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if ($('.answers').length == 0) {
    return;
  }
  
  consumer.subscriptions.create("CommentsChannel", {
    connected() {
      this.perform('follow', { question_id: gon.question_id });
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      let comment = JSON.parse(data);
      
      if (gon.current_user == comment.user) {
        return;
      }

      let comments_path = '';

      switch(comment.context) {
        case 'question':
          comments_path = '.question .comments';
          break;

        default:
          comments_path = '.' + comment.context + '-' + comment.commentable_id + ' .comments';    
      }

      if ($(comments_path).length != 0 ) {
        $(comments_path).append('<p>#' + comment.email + ': ' + comment.body + '</p>')
      }
    }
  });

})
