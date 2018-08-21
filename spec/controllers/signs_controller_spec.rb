# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignsController, type: :controller do
  describe '#show' do
    before { get :show, id: '1301' }

    it { expect(response).to have_http_status(:ok) }
  end

  describe '#search' do
    describe 'simple query' do
      before { get :search, s: 'hello' }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
