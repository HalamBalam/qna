require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let!(:list) { create_list(:answer, 3, question: question) }
    let(:readable) { question.answers.first }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API List Readable' do
      let(:resource) { :answer }
      let(:public_fields) { %w[id question_id body created_at updated_at user_id best] }
    end
  end


  describe 'GET /api/v1/answer/:id' do
    let!(:readable) { create(:answer, :with_attached_files) }
    let(:api_path) { api_v1_answer_path(readable) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Item Readable' do
      let(:resource) { :answer }
      let(:public_fields) { %w[id question_id body created_at updated_at user_id best] }
    end
  end


  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable' do
      let(:resource) { :answer }
    end
  end


  describe 'PATCH /api/v1/answers/:id' do
    let!(:changeable) { create(:answer) }
    let(:api_path) { api_v1_answer_path(changeable) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Changeable' do
      let(:resource) { :answer }
      let(:changeable_attributes) { { body: 'NewBody' } }
    end
  end


  describe 'DELETE /api/v1/answers/:id' do
    let!(:destructible) { create(:answer) }
    let(:api_path) { api_v1_answer_path(destructible) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Destructible' do
      let(:resource) { :answer }
    end
  end
end
