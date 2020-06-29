shared_examples_for 'API Creatable' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:model_klass) { resource.to_s.classify.constantize }

    describe 'with valid attributes' do
      it 'returns 200 status' do
        post api_path, params: { resource => attributes_for(resource), access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'creates item' do
        expect { post api_path,
                 params: { resource => attributes_for(resource), access_token: access_token.token },
                 headers: headers }.to change(model_klass, :count).by(1)
      end
    
      it 'creates item with valid attributes' do
        post api_path, params: { resource => attributes_for(resource), access_token: access_token.token }, headers: headers
        item = model_klass.first

        attributes_for(resource).each do |key, value|
          expect(value).to eq item.send(key)
        end

        expect(item.user_id).to eq access_token.resource_owner_id
      end
    end

    describe 'with links' do
      it 'returns 200 status' do
        post api_path, params: { resource => attributes_for(resource, :with_links), access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'creates links' do
        expect { post api_path,
                 params: { resource => attributes_for(resource, :with_links), access_token: access_token.token },
                 headers: headers }.to change(Link, :count).by(2)
      end

      it 'creates links with valid attributes' do
        post api_path, params: { resource => attributes_for(resource, :with_links), access_token: access_token.token }, headers: headers

        link_request = attributes_for(resource, :with_links)[:links_attributes].sort_by { |item| item[:name] }.first
        link = model_klass.first.links.sort_by { |item| item.name }.first

        link_request.each do |key, value|
          expect(value).to eq link.send(key)
        end
      end
    end

    describe 'with invalid attributes' do
      it 'returns 422 status' do
        post api_path, params: { resource => attributes_for(resource, :invalid), access_token: access_token.token }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create item' do
        expect { post api_path,
                 params: { resource => attributes_for(resource, :invalid), access_token: access_token.token },
                 headers: headers }.to_not change(model_klass, :count)
      end
    end
  end
end
