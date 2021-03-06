require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it_behaves_like 'voted controller' do
    let(:votable) { answer }
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders answer partial' do
      expect(response).to render_template 'answers/_answer'
    end
  end

  
  describe 'GET #new' do

    context 'authenticated user' do
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

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        get :new, params: { question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'POST #create' do
        
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new answer in the database' do
          expect { post :create,
                   params: { question_id: question, answer: attributes_for(:answer), user_id: user },
                   format: :js
                 }.to change(Answer, :count).by(1)
        end

        it 'has a valid question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }, format: :js
          expect(assigns(:answer).question).to eq question  
        end

        it 'has a valid user' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }, format: :js
          expect(assigns(:answer).user).to eq user 
        end

      end

      context 'with invalid attributes' do

        it 'does not save the answer' do
          expect { post :create,
                   params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user },
                   format: :js
                 }.to_not change(Answer, :count)  
        end

      end
   end

    context 'unauthenticated user' do
      it 'does not save the answer' do
        expect { post :create, 
                 params: { question_id: question, answer: attributes_for(:answer), user_id: user }
               }.to_not change(Answer, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'PATCH #update' do
    it_behaves_like 'updated controller' do
      let(:resource) { :answer }
      let(:updated_attributes) { { body: 'new body' } }
    end
  end


  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'authenticated user' do
      
      context 'user is the author of the answer' do
        before { login(answer.user) }  
        
        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end 
      end

      context 'user is not the author of the answer' do
        before { login(user) }

        it 'does not delete the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end

        it 'returns 403 status' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end

    end

    context 'unauthenticated user' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'returnes unauthorized error' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer, question: question) }

    context 'authenticated user' do

      context 'is the author of the question' do
        before { login(question.user) }  
        
        it 'marks the answer as the best' do
          patch :mark_as_best, params: { id: answer }, format: :js
          answer.reload
          expect(answer).to be_best  
        end

        it 'renders update view' do
          patch :mark_as_best, params: { id: answer }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'is not the author of the question' do
        before { login(user) }

        it 'does not mark the answer as the best' do
          patch :mark_as_best, params: { id: answer }, format: :js
          answer.reload
          expect(answer).not_to be_best
        end

        it 'returns 403 status' do
          patch :mark_as_best, params: { id: answer }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end

    end

    context 'unauthenticated user' do
      it 'does not mark the answer as the best' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end

      it 'returnes unauthorized error' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end

end
