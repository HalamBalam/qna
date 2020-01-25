require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show  
    end

  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'has a valid question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new  
    end  
  end

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { 
                                        question_id: question,
                                        answer: attributes_for(:answer),
                                        user_id: user 
                                        } }.to change(Answer, :count).by(1)
      end

      it 'has a valid question' do
        post :create, params: { 
                                question_id: question,
                                answer: attributes_for(:answer),
                                user_id: user
                              }
        expect(assigns(:answer).question).to eq question  
      end

      it 'redirects to question' do
        post :create, params: { 
                                question_id: question,
                                answer: attributes_for(:answer),
                                user_id: user
                              }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: {
                                        question_id: question,
                                        answer: attributes_for(:answer, :invalid),
                                        user_id: user
                                       } }.to_not change(Answer, :count)  
      end

      it 'redirects to question' do
        post :create, params: { 
                                question_id: question,
                                answer: attributes_for(:answer, :invalid),
                                user_id: user
                              }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  describe 'DELETE #delete' do
    before { login(user) }

    context 'user is the author of the answer' do
      let!(:answer) { create_answer(user, question) }
      
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end 
    end

    context 'user is not the author of the answer' do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to answer' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to assigns(:answer)
      end
    end

  end

end
