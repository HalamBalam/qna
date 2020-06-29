shared_examples_for 'API Destructible' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: destructible.user.id) }
    let(:model_klass) { resource.to_s.classify.constantize }
    
    it 'returns 200 status' do
      delete api_path, params: { id: destructible, access_token: access_token.token }, headers: headers
      expect(response).to be_successful
    end

    it 'deletes item' do
      expect {
        delete api_path, params: { id: destructible, access_token: access_token.token }, headers: headers
      }.to change(model_klass, :count).by(-1)
    end
  end
end
