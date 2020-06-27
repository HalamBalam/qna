shared_examples_for 'deleted attachments' do
  let!(:files_owner) { create(resource, :with_attached_files) }

  context 'user is the author of resource' do
    before { login(files_owner.user) }

    it 'deletes a file' do
      expect { delete :destroy, params: { id: files_owner.files.first }, format: :js }.to change(files_owner.files, :count).by(-1)
    end

    it 'renders update view' do
      delete :destroy, params: { id: files_owner.files.first }, format: :js  
      expect(response).to render_template :update
    end
  end

  context 'user is not the author of resource' do
    before { login(user) }

    it 'does not delete a file' do
      expect { delete :destroy, params: { id: files_owner.files.first }, format: :js }.to_not change(files_owner.files, :count)
    end

    it 'returns 403 status' do
      delete :destroy, params: { id: files_owner.files.first }, format: :js
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'unauthenticated user' do
    it 'does not delete a file' do
      expect { delete :destroy, params: { id: files_owner.files.first }, format: :js }.to_not change(files_owner.files, :count)
    end

    it 'returnes unauthorized error' do
      delete :destroy, params: { id: files_owner.files.first }, format: :js
      expect(response).to be_unauthorized
    end
  end
end
