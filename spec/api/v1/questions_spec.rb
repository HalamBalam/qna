require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

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
    let!(:question) { create(:question, :with_attached_files) }
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { question.comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id user_id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { question.links.sort_by { |item| item.created_at }.first }
        let(:link_response) { question_response['links'].sort_by { |item| item['created_at'] }.first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:url_list) { question.files.to_a.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) } }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq question.files.count
        end

        it 'returns url field' do
          expect(question_response['files']).to eq url_list
        end
      end
    end
  end


  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid attributes' do
        it 'returns 200 status' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates question' do
          expect { post api_path,
                   params: { question: attributes_for(:question), access_token: access_token.token },
                   headers: headers }.to change(Question, :count).by(1)
        end

        it 'creates question with valid attributes' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers
          question = Question.first

          attributes_for(:question).each do |key, value|
            expect(value).to eq question.send(key)
          end

          expect(question.user_id).to eq access_token.resource_owner_id
        end
      end

      describe 'with links' do
        it 'returns 200 status' do
          post api_path, params: { question: attributes_for(:question, :with_links), access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates links' do
          expect { post api_path,
                   params: { question: attributes_for(:question, :with_links), access_token: access_token.token },
                   headers: headers }.to change(Link, :count).by(2)
        end

        it 'creates links with valid attributes' do
          post api_path, params: { question: attributes_for(:question, :with_links), access_token: access_token.token }, headers: headers

          link_request = attributes_for(:question, :with_links)[:links_attributes].sort_by { |item| item[:name] }.first
          link = Question.first.links.sort_by { |item| item.name }.first

          link_request.each do |key, value|
            expect(value).to eq link.send(key)
          end
        end
      end

      describe 'with invalid attributes' do
        it 'returns 422 status' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create question' do
          expect { post api_path,
                   params: { question: attributes_for(:question, :invalid), access_token: access_token.token },
                   headers: headers }.to_not change(Question, :count)
        end
      end
    end
  end


  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid attributes' do
        let(:new_attributes) { { title: 'NewTitle', body: 'NewBody' } }

        before { patch api_path, params: { id: question, question: new_attributes, access_token: access_token.token }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'updates question attributes' do
          question.reload

          new_attributes.each do |key, value|
            expect(value).to eq question.send(key)
          end
        end
      end

      describe 'with links' do
        let(:new_attributes) { attributes_for(:question, :with_links) }

        it 'returns 200 status' do
          patch api_path, params: { id: question, question: new_attributes, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates links' do
          expect { patch api_path,
                   params: { id: question, question: new_attributes, access_token: access_token.token },
                   headers: headers }.to change(Link, :count).by(2)
        end

        it 'creates links with valid attributes' do
          patch api_path, params: { id: question, question: new_attributes, access_token: access_token.token }, headers: headers

          link_request = new_attributes[:links_attributes].sort_by { |item| item[:name] }.first
          link = Question.first.links.sort_by { |item| item.name }.first

          link_request.each do |key, value|
            expect(value).to eq link.send(key)
          end
        end
      end

      describe 'with invalid attributes' do
        let(:new_attributes) { attributes_for(:question, :invalid) }

        it 'returns 422 status' do
          patch api_path, params: { id: question, question: new_attributes, access_token: access_token.token }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change question' do
          expect { patch api_path,
                   params: { id: question, question: new_attributes, access_token: access_token.token },
                   headers: headers }.to_not change(question, :updated_at)
        end
      end
    end
  end


  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'returns 200 status' do
      delete api_path, params: { id: question, access_token: access_token.token }, headers: headers
      expect(response).to be_successful
    end

    it 'deletes question' do
      expect {
        delete api_path, params: { id: question, access_token: access_token.token }, headers: headers
      }.to change(Question, :count).by(-1)
    end
  end
end
