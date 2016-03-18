require 'rails_helper'

RSpec.describe VocabSheetsController, type: :controller do
  let(:valid_params) { FactoryGirl.attributes_for(:vocab_sheet) }
  let(:vocab_sheet) { FactoryGirl.create(:vocab_sheet) }
  let(:session) { { vocab_sheet_id: vocab_sheet.id } }

  let(:new_name) { 'this is the new name' }
  let(:new_attributes) { { vocab_sheet: { name: new_name } } }

  context '#show' do
    before { get :show }
    it { expect(response).to have_http_status(:ok) }
  end

  context '#update' do
    describe 'new vocab sheet' do
      before { patch :update, new_attributes }
      it { expect(assigns(:sheet)) }
      it { expect(response).to redirect_to root_path }
    end

    describe 'updating existing vocab sheet' do
      before { patch :update, new_attributes, session }
      it { expect(assigns(:sheet)).to eq(vocab_sheet) }
      it 'updates the sheet name' do
        vocab_sheet.reload
        expect(vocab_sheet.name).to eq(new_name)
      end
      it { expect(response).to redirect_to root_path }
    end
  end

  context '#destroy' do
    before { delete :destroy, id: vocab_sheet.id }
    it { expect(response).to redirect_to root_path }
  end
end
