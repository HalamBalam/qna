require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'DELETE #destroy (for answer)' do
    let!(:vote) { create(:vote, votable: answer, rating: 1) }

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

      it 'returns unprocessable_entity' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
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


  describe 'DELETE #destroy (for question)' do
    let!(:vote) { create(:vote, votable: question, rating: 1) }

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

      it 'returns unprocessable_entity' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
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
