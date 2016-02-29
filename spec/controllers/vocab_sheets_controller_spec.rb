require 'rails_helper'

RSpec.describe VocabSheetsController, type: :controller do
  let(:valid_params) { FactoryGirl.attributes_for(:vocab_sheet ) }
  let(:vocab_sheet) { FactoryGirl.create(:vocab_sheet)}

  describe '#show' do
    before { get :show }
    it { expect(response).to have_http_status(:ok) }
  end

  describe '#update' do
    it 'updates an vocab sheet' do
      patch :update, vocab_sheet: valid_params
      expect(response).to have_http_status(:found)
    end
  end
  describe '#destroy' do
    before { vocab_sheet.save! }
    it 'destroys an item' do
      delete :destroy, id: vocab_sheet.id
      expect(response).to have_http_status(:found)
    end
  end
end
