shared_examples_for 'API List Readable' do
  context 'authorized' do
    let(:list_name) { "#{resource.to_s}s" }
    let(:readable_response) { json[list_name].first }
    let(:access_token) { create(:access_token) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns list of items' do
      expect(json[list_name].size).to eq list.size
    end

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(readable_response[attr]).to eq readable.send(attr).as_json
      end
    end
  end
end
