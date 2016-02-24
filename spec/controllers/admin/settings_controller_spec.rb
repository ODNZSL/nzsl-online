require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  let(:username) { 'test' }
  let(:password) { 'test' }
  before { NZSL_ADMIN_ACCESS[username] = Digest::SHA1.hexdigest(password) }

  let(:setting) { FactoryGirl.create(:setting) }
  let(:valid_params) do
    { "#{setting.key}": 'newvalue' }
  end
  context 'when HTTP auth credentials are good' do
    before do
      basic_auth 'test', 'test'
    end
    describe 'GET #show' do
      before do
        get :show
      end
      it { expect(response).to have_http_status(:redirect) }
    end

    describe 'GET #edit' do
      before do
        get :edit
      end
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:edit) }
    end

    describe '#update' do
      before { patch :update, settings: valid_params }
      it { expect(response).to have_http_status(302) }
      it 'updates the setting' do
        setting.reload
        expect(setting.value).to eq('newvalue')
      end
    end
  end

  context 'Not logged in' do
    describe '#show' do
      before { get :show }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe '#edit' do
      before { get :edit }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe '#update' do
      before { patch :update }
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  context 'when HTTP Digest auth credentials are invalid' do
    before do
      basic_auth 'alice', 'secret'
      get :show
    end
    it { expect(response).to have_http_status(:unauthorized) }
  end
end
