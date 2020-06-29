shared_examples_for 'updated controller' do
  let(:updated) { create(resource) }

  context 'authenticated user' do
    context 'is the author of updated' do
      before { login(updated.user) }

      it 'changes attributes' do
        patch :update, params: { id: updated, resource => updated_attributes }, format: :js
        
        updated.reload
        updated_attributes.each do |key, value|
          expect(updated.send(key)).to eq value
        end
      end

      it 'attaches new files' do
        expect do
          files = [
            Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))),
            Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
          ]
          patch :update, params: { id: updated, resource => { files: files } }, format: :js
          updated.reload

        end.to change(updated.files, :count).by(2)
      end

      it 'renders update view' do
        patch :update, params: { id: updated, resource => updated_attributes }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'edits with invalid attributes' do
      before { login(updated.user) }

      it 'does not change attributes' do
        expect do
          patch :update, params: { id: updated, resource => attributes_for(resource, :invalid) }, format: :js
          updated.reload
        end.to_not change(updated, :updated_at)  
      end

      it 'renders update view' do
        patch :update, params: { id: updated, resource => attributes_for(resource, :invalid) }, format: :js  
        expect(response).to render_template :update
      end
    end

    context "is not the author of updated" do
      before { login(user) }

      it 'does not change attributes' do
        expect do
          patch :update, params: { id: updated, resource => updated_attributes }, format: :js
          updated.reload
        end.to_not change(updated, :updated_at)  
      end

      it 'returns 403 status' do
        patch :update, params: { id: updated, resource => updated_attributes }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'unauthenticated user' do
    it 'does not change attributes' do
      expect do
        patch :update, params: { id: updated, resource => updated_attributes }, format: :js
        updated.reload
      end.to_not change(updated, :updated_at)  
    end

    it 'returnes unauthorized error' do
      patch :update, params: { id: updated, resource => updated_attributes }, format: :js
      expect(response).to be_unauthorized
    end
  end
end
