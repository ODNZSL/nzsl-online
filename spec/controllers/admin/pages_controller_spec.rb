require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  let(:username) { 'test'}
  let(:password) { 'test' }
  before do
    NZSL_ADMIN_ACCESS[username] = Digest::SHA1.hexdigest(password)
  end
  context "when HTTP auth credentials are good" do
    before do
      basic_auth username, password
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
  end


  context 'Not logged in' do
    describe '#index' do
      before { get :show }
      it { expect(response).to have_http_status(:unauthorized) }
    end

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
