module ControllerHelpers

  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def create_question(user)
    question = user.questions.new
    question.title = 'New question'
    question.body = 'New body'
    question.save!
    question  
  end

  def create_answer(user, question)
    answer = question.answers.new
    answer.user = user
    answer.body = 'New body'
    answer.save!
    answer
  end
  
end
