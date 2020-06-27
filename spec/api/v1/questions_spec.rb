require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let!(:list) { create_list(:question, 2) }
    let(:readable) { list.first }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API List Readable' do
      let(:resource) { :question }
      let(:public_fields) { %w[id title body created_at updated_at] }
    end

    context 'authorized' do
      let(:question) { readable }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { question.answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end


  describe 'GET /api/v1/questions/:id' do
    let!(:readable) { create(:question, :with_attached_files) }
    let(:api_path) { api_v1_question_path(readable) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Item Readable' do
      let(:resource) { :question }
      let(:public_fields) { %w[id user_id title body created_at updated_at] }
    end
  end


  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable' do
      let(:resource) { :question }
    end
  end


  describe 'PATCH /api/v1/questions/:id' do
    let!(:changeable) { create(:question) }
    let(:api_path) { api_v1_question_path(changeable) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Changeable' do
      let(:resource) { :question }
      let(:changeable_attributes) { { title: 'NewTitle', body: 'NewBody' } }
    end
  end


  describe 'DELETE /api/v1/questions/:id' do
    let!(:destructible) { create(:question) }
    let(:api_path) { api_v1_question_path(destructible) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Destructible' do
      let(:resource) { :question }
    end
  end
end
