require 'rails_helper'

RSpec.shared_examples_for 'voted' do
  
  let(:votable) { create(described_class.to_s.gsub(/sController/) { '' }.underscore.to_sym) }
  let(:user) { create(:user) }

  describe 'PATCH #vote_yes' do

    context 'user is not the author of votable' do
      before { login(user) }

      it 'saves a new vote in the database' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'increases the rating' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to change(votable, :rating).by(1)
      end

      it 'returns success' do
        patch :vote_yes, params: { id: votable }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'user is the author of votable' do
      before { login(votable.user) }

      it 'does not save a new vote in the database' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not increase the rating' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returns unprocessable_entity' do
        patch :vote_yes, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'user could not vote more than one time' do
      before { login(user) }
      before { create(:vote, votable: votable, user: user, rating: 1) }
      
      it 'does not save a new vote in the database' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not increase the rating' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returns unprocessable_entity' do
        patch :vote_yes, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)  
      end
    end

    context 'unauthenticated user' do
      it 'does not save a new vote in the database' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not increase the rating' do
        expect { patch :vote_yes, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returnes unauthorized error' do
        patch :vote_yes, params: { id: votable }, format: :json
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'PATCH #vote_no' do

    context 'user is not the author of votable' do
      before { login(user) }

      it 'saves a new vote in the database' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'decreases the rating' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to change(votable, :rating).by(-1)
      end

      it 'returns success' do
        patch :vote_no, params: { id: votable }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'user is the author of votable' do
      before { login(votable.user) }

      it 'does not save a new vote in the database' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not decrease the rating' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returns unprocessable_entity' do
        patch :vote_no, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'user could not vote more than one time' do
      before { login(user) }
      before { create(:vote, votable: votable, user: user, rating: -1) }
      
      it 'does not save a new vote in the database' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not decrease the rating' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returns unprocessable_entity' do
        patch :vote_no, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)  
      end
    end

    context 'unauthenticated user' do
      it 'does not save a new vote in the database' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'does not decrease the rating' do
        expect { patch :vote_no, params: { id: votable }, format: :json }.to_not change(votable, :rating)
      end

      it 'returnes unauthorized error' do
        patch :vote_no, params: { id: votable }, format: :json
        expect(response).to be_unauthorized
      end
    end

  end

end
