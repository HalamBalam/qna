require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    context 'empty query' do
      before { get :search }

      it 'does not search in database' do
        expect(assigns(:result)).to_not be
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        expect(response).to render_template :search  
      end
    end
    

    context 'with filled query' do
      before { get :search, params: { scope: 'all', q: 'test' } }

      it 'searches in database' do
        expect(assigns(:result)).to be
      end

      it 'sets instance variables' do
        expect(assigns(:scope)).to eq 'all'
        expect(assigns(:query)).to eq 'test'
        expect(assigns(:page)).to eq 1
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        expect(response).to render_template :search  
      end
    end
  end
end
