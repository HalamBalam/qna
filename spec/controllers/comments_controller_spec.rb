require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create (for question)' do

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new comment in the database' do
          expect { post :create,
                   params: { question_id: question, comment: attributes_for(:comment, commentable: question), context: 'question' },
                   format: :js
                 }.to change(Comment, :count).by(1)
        end

        it 'has a valid question' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), context: 'question' }, format: :js
          expect(assigns(:comment).commentable).to eq question  
        end

        it 'has a valid user' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), context: 'question' }, format: :js
          expect(assigns(:comment).user).to eq user 
        end

      end

      context 'with invalid attributes' do

        it 'does not save the comment' do
          expect { post :create,
                   params: { question_id: question, comment: attributes_for(:comment, :invalid, commentable: question), context: 'question' },
                   format: :js
                 }.to_not change(Comment, :count)  
        end

      end
   end

   context 'unauthenticated user' do
      it 'does not save the comment' do
        expect { post :create, 
                 params: { question_id: question, comment: attributes_for(:comment, commentable: question), context: 'question' },
                 format: :js
               }.to_not change(Comment, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, commentable: question), context: 'question' }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'POST #create (for answer)' do

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new comment in the database' do
          expect { post :create,
                   params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), context: 'answer' },
                   format: :js
                 }.to change(Comment, :count).by(1)
        end

        it 'has a valid answer' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), context: 'answer' }, format: :js
          expect(assigns(:comment).commentable).to eq answer  
        end

        it 'has a valid user' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), context: 'answer' }, format: :js
          expect(assigns(:comment).user).to eq user 
        end

      end

      context 'with invalid attributes' do

        it 'does not save the comment' do
          expect { post :create,
                   params: { answer_id: answer, comment: attributes_for(:comment, :invalid, commentable: answer), context: 'answer' },
                   format: :js
                 }.to_not change(Comment, :count)  
        end

      end
   end

   context 'unauthenticated user' do
      it 'does not save the comment' do
        expect { post :create, 
                 params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), context: 'answer' },
                 format: :js
               }.to_not change(Comment, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { answer_id: answer, comment: attributes_for(:comment, commentable: answer), context: 'answer' }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end

end
