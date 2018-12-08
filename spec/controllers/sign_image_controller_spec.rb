# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignImageController, type: :controller do
  let(:valid_params) { { height: 50, width: 40, filename: '5519/victoria_university-5519-default.png' } }

  describe '#show' do
    context 'good request' do
      before { get :show, params: valid_params }

      it { expect(response).to have_http_status(:ok) }
    end

    context 'Partial request, fall back on defaults' do
      before { get :show, params: { filename: '5519/victoria_university-5519-default.png' } }

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

    context 'when height and width params are present' do
      before { get :show, params: valid_params }

      it 'returns an image with those dimensions' do
        expect(assigns(:local_filename)).to include('40x50-5519-victoria_university-5519-default.png')
      end
    end
  end
end
