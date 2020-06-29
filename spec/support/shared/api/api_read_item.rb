shared_examples_for 'API Item Readable' do
  context 'authorized' do
    let!(:comments) { create_list(:comment, 3, commentable: readable) }
    let!(:links) { create_list(:link, 3, linkable: readable) }
    let(:access_token) { create(:access_token) }
    let(:readable_response) { json[resource.to_s] }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(readable_response[attr]).to eq readable.send(attr).as_json
      end
    end

    describe 'comments' do
      let(:comment) { readable.comments.first }
      let(:comment_response) { readable_response['comments'].first }

      it 'returns list of comments' do
        expect(readable_response['comments'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id user_id body created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end

    describe 'links' do
      let(:link) { readable.links.sort_by { |item| item.created_at }.first }
      let(:link_response) { readable_response['links'].sort_by { |item| item['created_at'] }.first }

      it 'returns list of links' do
        expect(readable_response['links'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end
    end

    describe 'files' do
      let(:url_list) { readable.files.to_a.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) } }

      it 'returns list of files' do
        expect(readable_response['files'].size).to eq readable.files.count
      end

      it 'returns url field' do
        expect(readable_response['files']).to eq url_list
      end
    end
  end
end
