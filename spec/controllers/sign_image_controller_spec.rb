require 'rails_helper'

RSpec.describe SignImageController, type: :controller do
  let(:valid_params) { { height: 50, width: 40, filename: '1124/picture-W99-28.png' } }
  describe '#show' do
    context 'good request' do
      before { get :show, params: valid_params }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'Partial request, fall back on defaults' do
      before { get :show, params: { filename: '1124/picture-W99-28.png' } }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'image request looks good, but image does not exist' do
      before { get :show, params: { filename: '1124/missing.png' } }
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'invalid request' do
      before { get :show, params: { filename: '/etc/passwd' } }
      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
