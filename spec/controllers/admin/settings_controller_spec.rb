require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
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
      authenticate_with_http_digest('invalid_login', 'invalid_password') do
        get :show
      end
    end
    it { expect(response).to have_http_status(:unauthorized) }
  end
end
