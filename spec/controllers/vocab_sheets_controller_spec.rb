# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VocabSheetsController, type: :controller do
  let(:vocab_sheet) { FactoryBot.create(:vocab_sheet) }
  let(:session) { { vocab_sheet_id: vocab_sheet.id } }

  let(:new_name) { Faker::Name.name }
  let(:valid_attributes) do
    { vocab_sheet: { name: new_name } }
  end

  describe '#show' do
    before { get :show }
    it { expect(response).to have_http_status(:ok) }
  end

  describe '#update' do
    before do
      allow_any_instance_of(Browser::Generic)
        .to receive(:modern?)
        .and_return(true)
    end

    context 'new vocab sheet' do
      before { patch :update, valid_attributes }
      it { expect(assigns(:sheet)) }
      it { expect(response).to redirect_to root_path }
    end

    context 'existing vocab sheet' do
      before { patch :update, valid_attributes, session }

      it 'updates the sheet instance variable' do
        expect(assigns(:sheet)).to eq(vocab_sheet)
      end

      it 'updates the sheet name' do
        vocab_sheet.reload
        expect(vocab_sheet.name).to eq(new_name)
      end

      it 'redirects to the homepage' do
        expect(response).to redirect_to root_path
      end
    end

    context 'successful update' do
      it 'displays a success flash message' do
        patch :update, valid_attributes, session
        expect(flash[:notice]).to eq I18n.t('vocab_sheet.sheet.update_success')
      end
    end
  end

  describe '#destroy' do
    let!(:vocab_sheet) { FactoryBot.create(:vocab_sheet) }
    let(:valid_request) { delete :destroy, id: vocab_sheet.id }
    let(:invalid_request) do
      delete :destroy, id: vocab_sheet.id + 100
    end

    before do
      allow_any_instance_of(Browser::Generic)
        .to receive(:modern?)
        .and_return(true)
    end

    context 'successful deletion' do
      it 'decrements the vocab_sheet count' do
        expect { valid_request }.to change(VocabSheet, :count).by(-1)
      end

      it 'deletes the vocab_sheet specified' do
        valid_request
        expect(VocabSheet.find_by(id: vocab_sheet.id)).to be_nil
      end

      it 'displays a success flash message' do
        valid_request
        expect(flash[:notice]).to eq I18n.t('vocab_sheet.delete_success')
      end
    end

    context 'unsuccessful deletion' do
      it 'does not change the VocabSheet count' do
        expect { invalid_request }.not_to change(VocabSheet, :count)
      end

      it 'displays an error flash message' do
        invalid_request
        expect(flash[:error]).to eq I18n.t('vocab_sheet.delete_failure')
      end
    end

    it 'redirects to the homepage' do
      # it redirects to the homepage for valid or invalid requests
      [valid_request, invalid_request].each do |request|
        request
        expect(response).to redirect_to root_path
      end
    end
  end
end
