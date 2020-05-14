import consumer from "./consumer"

consumer.subscriptions.create('QuestionsChannel', {
  connected() {
    this.perform('follow');
  },

  received(data) {
    let question = JSON.parse(data);

    let xhr = new XMLHttpRequest();
    xhr.open('GET', question.path, false);
    xhr.send();

    if (xhr.status == 200) {
      $('.questions-list').append(xhr.responseText);
    }
  }
})
