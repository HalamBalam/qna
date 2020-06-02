require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { {:provider => 'github', :uid => 123, :info => { :email => 'test@github.com' } } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end


  describe 'VK' do
    
    context 'provider returns email' do
      let(:oauth_data) { {:provider => 'vkontakte', :uid => 123, :info => { :email => 'test@vk.com' } } }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :vkontakte
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :vkontakte
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth)
          get :vkontakte
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end


    context 'provider does not return email' do
      let(:oauth_data) { {:provider => 'vkontakte', :uid => 123, :info => {} } }

      context 'authorization exists and confirmed' do
        let!(:user) { create(:user) }
        let!(:authorization) { create(:authorization, user: user, provider: oauth_data[:provider], uid: oauth_data[:uid], confirmed: true) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        end

        it 'login user' do
          get :vkontakte
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          get :vkontakte
          expect(response).to redirect_to root_path
        end
      end


      context 'authorization exists and not confirmed' do
        let!(:user) { create(:user) }
        let!(:authorization) { create(:authorization, user: user, provider: oauth_data[:provider], uid: oauth_data[:uid]) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        end

        it 'does not login user' do
          get :vkontakte
          expect(subject.current_user).to_not be
        end

        it 'renders ask_user_email template' do
          get :vkontakte
          expect(response).to render_template 'authorizations/ask_user_email'
        end
      end


      context 'authorization does not exist' do
        let!(:user) { create(:user) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        end

        it 'does not login user' do
          get :vkontakte
          expect(subject.current_user).to_not be
        end

        it 'renders ask_user_email template' do
          get :vkontakte
          expect(response).to render_template 'authorizations/ask_user_email'
        end
      end
    end

  end
end
