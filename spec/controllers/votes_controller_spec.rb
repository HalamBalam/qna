require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:vote) { create(:vote, votable: create(:answer), rating: 1) }

  describe 'DELETE #destroy' do
    context 'user deletes his vote' do
      before { login(vote.user) }

      it 'deletes the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to change(vote.user.votes, :count).by(-1)
      end

      it 'returns success' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context "user could not delete another user's vote" do
      before { login(user) }

      it 'does not delete the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to_not change(Vote, :count)
      end

      it 'returns 403 status' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete the vote' do
        expect { delete :destroy, params: { id: vote }, format: :json }.to_not change(Vote, :count)
      end
      
      it 'returnes unauthorized error' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to be_unauthorized
      end  
    end
  end
end
