require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id question_id body created_at updated_at user_id best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end


  describe 'GET /api/v1/answer/:id' do
    let!(:answer) { create(:answer, :with_attached_files) }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id question_id body created_at updated_at user_id best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id user_id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { answer.links.sort_by { |item| item.created_at }.first }
        let(:link_response) { answer_response['links'].sort_by { |item| item['created_at'] }.first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:url_list) { answer.files.to_a.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) } }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq answer.files.count
        end

        it 'returns url field' do
          expect(answer_response['files']).to eq url_list
        end
      end
    end
  end


  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid attributes' do
        it 'returns 200 status' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates answer' do
          expect { post api_path,
                   params: { answer: attributes_for(:answer), access_token: access_token.token },
                   headers: headers }.to change(Answer, :count).by(1)
        end
      
        it 'creates answer with valid attributes' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }, headers: headers
          answer = Answer.first

          attributes_for(:answer).each do |key, value|
            expect(value).to eq answer.send(key)
          end

          expect(answer.user_id).to eq access_token.resource_owner_id
        end
      end

      describe 'with links' do
        it 'returns 200 status' do
          post api_path, params: { answer: attributes_for(:answer, :with_links), access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates links' do
          expect { post api_path,
                   params: { answer: attributes_for(:answer, :with_links), access_token: access_token.token },
                   headers: headers }.to change(Link, :count).by(2)
        end

        it 'creates links with valid attributes' do
          post api_path, params: { answer: attributes_for(:answer, :with_links), access_token: access_token.token }, headers: headers

          link_request = attributes_for(:answer, :with_links)[:links_attributes].sort_by { |item| item[:name] }.first
          link = Answer.first.links.sort_by { |item| item.name }.first

          link_request.each do |key, value|
            expect(value).to eq link.send(key)
          end
        end
      end

      describe 'with invalid attributes' do
        it 'returns 422 status' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create question' do
          expect { post api_path,
                   params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token },
                   headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end


  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid attributes' do
        let(:new_attributes) { { body: 'NewBody' } }

        before { patch api_path, params: { id: answer, answer: new_attributes, access_token: access_token.token }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'updates answer attributes' do
          answer.reload

          new_attributes.each do |key, value|
            expect(value).to eq answer.send(key)
          end
        end
      end

      describe 'with links' do
        let(:new_attributes) { attributes_for(:answer, :with_links) }

        it 'returns 200 status' do
          patch api_path, params: { id: answer, answer: new_attributes, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        it 'creates links' do
          expect { patch api_path,
                   params: { id: answer, answer: new_attributes, access_token: access_token.token },
                   headers: headers }.to change(Link, :count).by(2)
        end

        it 'creates links with valid attributes' do
          patch api_path, params: { id: answer, answer: new_attributes, access_token: access_token.token }, headers: headers

          link_request = new_attributes[:links_attributes].sort_by { |item| item[:name] }.first
          link = Answer.first.links.sort_by { |item| item.name }.first

          link_request.each do |key, value|
            expect(value).to eq link.send(key)
          end
        end
      end

      describe 'with invalid attributes' do
        let(:new_attributes) { attributes_for(:answer, :invalid) }

        it 'returns 422 status' do
          patch api_path, params: { id: answer, answer: new_attributes, access_token: access_token.token }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change answer' do
          expect { patch api_path,
                   params: { id: answer, answer: new_attributes, access_token: access_token.token },
                   headers: headers }.to_not change(answer, :updated_at)
        end
      end
    end 
  end


  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { api_v1_answer_path(answer) }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'returns 200 status' do
      delete api_path, params: { id: answer, access_token: access_token.token }, headers: headers
      expect(response).to be_successful
    end

    it 'deletes answer' do
      expect {
        delete api_path, params: { id: answer, access_token: access_token.token }, headers: headers
      }.to change(Answer, :count).by(-1)
    end
  end
end
