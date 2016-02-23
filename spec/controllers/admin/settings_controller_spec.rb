require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do

  before do
    NZSL_ADMIN_ACCESS['test'] = Digest::SHA1.hexdigest("test")
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

  context "when HTTP auth credentials are good" do
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

  end
end
