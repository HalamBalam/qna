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

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do

        it 'does not save the answer' do
          expect { post :create,
                   params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user },
                   format: :js
                 }.to_not change(Answer, :count)  
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end
   end

    context 'unauthenticated user' do
      it 'does not save the answer' do
        expect { post :create, 
                 params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user }
               }.to_not change(Answer, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'authenticated user' do
      context 'edits his answer with valid attributes' do
        before { login(answer.user) }

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js  
          expect(response).to render_template :update
        end
      end

      context 'edits his answer with invalid attributes' do
        before { login(answer.user) }

        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            answer.reload
          end.to_not change(answer, :body)  
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js  
          expect(response).to render_template :update
        end
      end

      context "edits another user's answer" do
        before { login(user) }

        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
          end.to_not change(answer, :body)  
        end

        it 'redirects to answer' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to redirect_to assigns(:answer)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
        end.to_not change(answer, :body)  
      end

      it 'returnes unauthorized error' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'DELETE #delete' do
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

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
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
          question.reload
          expect(question.best_answer).to eq answer  
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
          question.reload
          expect(question.best_answer).to_not eq answer
        end

        it 'renders update view' do
          patch :mark_as_best, params: { id: answer }, format: :js
          expect(response).to render_template :update
        end
      end

    end

    context 'unauthenticated user' do
      it 'does not mark the answer as the best' do
        patch :mark_as_best, params: { id: answer }, format: :js
        question.reload
        expect(question.best_answer).to_not eq answer
      end

      it 'returnes unauthorized error' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end

end
