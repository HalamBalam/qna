require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  
  let!(:question) { create(:question, :with_attached_files) }
  let!(:answer) { create(:answer, :with_attached_files) }
  let!(:user) { create(:user) }

  
  describe 'DELETE #destroy (for answer)' do

    context 'user is the author of the answer' do
      before { login(answer.user) }

      it 'deletes a file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)  
      end

      it 'renders update view' do
        delete :destroy, params: { id: answer.files.first }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'user is not the author of the answer' do
      before { login(user) }

      it 'does not delete a file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
      end

      it 'renders update view' do
        delete :destroy, params: { id: answer.files.first }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
      end

      it 'returnes unauthorized error' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'DELETE #destroy (for question)' do
    
    context 'user is the author of the question' do
      before { login(question.user) }

      it 'deletes a file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)  
      end

      it 'renders update view' do
        delete :destroy, params: { id: question.files.first }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'user is not the author of the question' do
      before { login(user) }

      it 'does not delete a file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'renders update view' do
        delete :destroy, params: { id: question.files.first }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'returnes unauthorized error' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end

end
