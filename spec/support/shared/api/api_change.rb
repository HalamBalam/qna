shared_examples_for 'API Changeable' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: changeable.user.id) }
    let(:model_klass) { resource.to_s.classify.constantize }

    describe 'with valid attributes' do
      let(:new_attributes) { changeable_attributes }

      before { patch api_path, params: { id: changeable, resource => new_attributes, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates item attributes' do
        changeable.reload

        new_attributes.each do |key, value|
          expect(value).to eq changeable.send(key)
        end
      end
    end

    describe 'with links' do
      let(:new_attributes) { attributes_for(resource, :with_links) }

      it 'returns 200 status' do
        patch api_path, params: { id: changeable, resource => new_attributes, access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'creates links' do
        expect { patch api_path,
                 params: { id: changeable, resource => new_attributes, access_token: access_token.token },
                 headers: headers }.to change(Link, :count).by(2)
      end

      it 'creates links with valid attributes' do
        patch api_path, params: { id: changeable, resource => new_attributes, access_token: access_token.token }, headers: headers

        link_request = new_attributes[:links_attributes].sort_by { |item| item[:name] }.first
        link = model_klass.first.links.sort_by { |item| item.name }.first

        link_request.each do |key, value|
          expect(value).to eq link.send(key)
        end
      end
    end

    describe 'with invalid attributes' do
      let(:new_attributes) { attributes_for(resource, :invalid) }

      it 'returns 422 status' do
        patch api_path, params: { id: changeable, resource => new_attributes, access_token: access_token.token }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not change item' do
        expect { patch api_path,
                 params: { id: changeable, resource => new_attributes, access_token: access_token.token },
                 headers: headers }.to_not change(changeable, :updated_at)
      end
    end
  end
end
