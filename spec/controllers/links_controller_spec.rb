require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let!(:user) { create(:user) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy (for answer)' do

    context 'user is the author of the answer' do
      before { login(answer.user) }

      it 'deletes a link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to change(answer.links, :count).by(-1)  
      end

      it 'renders update view' do
        delete :destroy, params: { id: answer_link }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'user is not the author of the answer' do
      before { login(user) }

      it 'does not delete a link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to_not change(answer.links, :count)
      end

      it 'renders update view' do
        delete :destroy, params: { id: answer_link }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to_not change(answer.links, :count)
      end

      it 'returnes unauthorized error' do
        delete :destroy, params: { id: answer_link }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end


  describe 'DELETE #destroy (for question)' do

    context 'user is the author of the question' do
      before { login(question.user) }

      it 'deletes a link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to change(question.links, :count).by(-1)  
      end

      it 'renders update view' do
        delete :destroy, params: { id: question_link }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'user is not the author of the question' do
      before { login(user) }

      it 'does not delete a link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(question.links, :count)
      end

      it 'renders update view' do
        delete :destroy, params: { id: question_link }, format: :js  
        expect(response).to render_template :update
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(question.links, :count)
      end

      it 'returnes unauthorized error' do
        delete :destroy, params: { id: question_link }, format: :js
        expect(response).to be_unauthorized
      end
    end

  end

end
