require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:commentable) { create(:answer) }
  let(:id) { :answer_id }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new comment in the database' do
          expect { post :create,
                   params: { id => commentable, comment: attributes_for(:comment, commentable: commentable) },
                   format: :js
                 }.to change(Comment, :count).by(1)
        end

        it 'has a valid commentable' do
          post :create, params: { id => commentable, comment: attributes_for(:comment, commentable: commentable) }, format: :js
          expect(assigns(:comment).commentable).to eq commentable  
        end

        it 'has a valid user' do
          post :create, params: { id => commentable, comment: attributes_for(:comment, commentable: commentable) }, format: :js
          expect(assigns(:comment).user).to eq user 
        end

      end

      context 'with invalid attributes' do

        it 'does not save the comment' do
          expect { post :create,
                   params: { id => commentable, comment: attributes_for(:comment, :invalid, commentable: commentable) },
                   format: :js
                 }.to_not change(Comment, :count)  
        end

      end
   end

   context 'unauthenticated user' do
      it 'does not save the comment' do
        expect { post :create, 
                 params: { id => commentable, comment: attributes_for(:comment, commentable: commentable) },
                 format: :js
               }.to_not change(Comment, :count)  
      end

      it 'redirects to sign in page' do
        post :create, params: { id => commentable, comment: attributes_for(:comment, commentable: commentable) }, format: :js
        expect(response).to be_unauthorized
      end
    end
  end
end
