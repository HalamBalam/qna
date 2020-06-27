require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it_behaves_like 'voted controller' do
    let(:votable) { question }
  end

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
    it_behaves_like 'updated controller' do
      let(:resource) { :question }
      let(:updated_attributes) { { title: 'new title', body: 'new body' } }
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
