require 'rails_helper'

RSpec.describe VocabSheetsController, type: :controller do
  let(:valid_params) do
    {
      vocab_sheet: {
        name: 'unit tests sheet'
      }
    }
  end

  let(:vocab_sheet) do
    VocabSheet.new(valid_params[:vocab_sheet])
  end

  describe '#show' do
    it 'shows our vocab seet' do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'updates an vocab sheet' do
      patch :update, valid_params
      expect(response).to have_http_status(:found)
    end
  end
  describe '#destroy' do
    before :each do
      vocab_sheet.save!
    end
    it 'destroys an item' do
      delete :destroy, id: vocab_sheet.id
      expect(response).to have_http_status(:found)
    end
  end
end
