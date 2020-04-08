require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:reward) { create(:reward, user_id: user.id) }


  describe 'GET #index' do

    context 'unauthenticated user' do
      before { get :index }

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      before { login(user) }
      before { get :index }

      it "populates an array of user's rewards" do
        expect(assigns(:rewards)).to match_array(user.rewards)  
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

  end

end
