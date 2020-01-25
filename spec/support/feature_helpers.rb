module FeatureHelpers
  
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
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
