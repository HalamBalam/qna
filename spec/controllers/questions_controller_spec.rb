require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it_behaves_like 'voted'

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assings new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assings new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show  
    end
  end


  describe 'GET #new' do

    context 'authenticated user' do
      before { login(user) }
      before { get :new }

      it 'assigns a new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new link to @question.links.first' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'assigns a new reward to @question.reward' do
        expect(assigns(:question).reward).to be_a_new(Reward)
      end

      it 'renders new view' do
        expect(response).to render_template :new  
      end
    end

    context 'unauthenticated user' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'POST #create' do

    context 'authenticated user' do
      before { login(user) }
      
      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create,
                   params: { question: attributes_for(:question), user_id: user }
                 }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question), user_id: user }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create,
                   params: { question: attributes_for(:question, :invalid), user_id: user }
                 }.to_not change(Question, :count)  
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid), user_id: user }
          expect(response).to render_template :new
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save the question' do
        expect { post :create,
                 params: { question: attributes_for(:question, :invalid), user_id: user }
               }.to_not change(Question, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { question: attributes_for(:question), user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'PATCH #update' do
    let!(:question) { create(:question) }

    context 'authenticated user' do
      context 'user is the author of the question' do
        before { login(question.user) }

        context 'with valid attributes' do
          it 'changes question attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'attaches new files' do
            expect do
              files = [
                Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))),
                Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
              ]
              patch :update, params: { id: question, question: { title: question.title, body: question.body, files: files } }, format: :js
              question.reload

            end.to change(question.files, :count).by(2)
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js  
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change question attributes' do
            expect do
              patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
              question.reload
            end.to_not change(question, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js  
            expect(response).to render_template :update
          end
        end

      end

      context 'user is not the author of the question' do
        before { login(user) }

        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
            question.reload
          end.to_not change(question, :body)
        end

        it 'returns 403 status' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
        end.to_not change(question, :body)
      end

      it 'returnes unauthorized error' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'DELETE #delete' do
    let!(:question) { create(:question) }

    context 'authenticated user' do

      context 'user is the author of the question' do
        before { login(question.user) }
        
        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end 
      end

      context 'user is not the author of the question' do
        before { login(user) }

        it 'does not delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to root path' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
        
      it 'redirects to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end    

  end

end
