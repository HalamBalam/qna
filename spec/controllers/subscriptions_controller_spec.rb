require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      it 'saves a new subscription in the database' do
        expect { post :create,
                 params: { question_id: question, user_id: user }, format: :js
               }.to change(user.subscriptions, :count).by(1)
      end

      it 'has a valid question' do
        post :create, params: { question_id: question, user_id: user }, format: :js
        expect(assigns(:subscription).question).to eq question
      end

      it 'has a valid user' do
        post :create, params: { question_id: question, user_id: user }, format: :js
        expect(assigns(:subscription).user).to eq user
      end
    end

    context 'unauthenticated user' do
      it 'does not save the comment' do
        expect { post :create, 
                 params: { question_id: question, user_id: user }, format: :js
               }.to_not change(Subscription, :count)  
      end

      it 'returns unauthorized error' do
        post :create, params: { question_id: question, user_id: user }, format: :js
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription) }

    context 'user deletes his subscription' do
      before { login(subscription.user) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(subscription.user.subscriptions, :count).by(-1)
      end

      it 'returns success' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to have_http_status(:success)
      end
    end

    context "user could not delete another user's subscription" do
      before { login(user) }

      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(Subscription, :count)
      end

      it 'returns 403 status' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(Subscription, :count)
      end
      
      it 'returnes unauthorized error' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to be_unauthorized
      end  
    end
  end
end
