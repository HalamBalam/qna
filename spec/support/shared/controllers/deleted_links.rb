shared_examples_for 'deleted links' do
  let!(:linkable) { create(resource) }
  let!(:link) { create(:link, linkable: linkable) }

  context 'user is the author of the linkable' do
    before { login(linkable.user) }

    it 'deletes a link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to change(linkable.links, :count).by(-1)
    end

    it 'renders update view' do
      delete :destroy, params: { id: link }, format: :js  
      expect(response).to render_template :update
    end
  end

  context 'user is not the author of the linkable' do
    before { login(user) }

    it 'does not delete a link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to_not change(linkable.links, :count)
    end

    it 'returns 403 status' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'unauthenticated user' do
    it 'does not delete a link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to_not change(linkable.links, :count)
    end

    it 'returnes unauthorized error' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to be_unauthorized
    end
  end
end
