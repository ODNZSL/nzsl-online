require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  describe '#show' do
    context "not logged in" do
      before { get :show }
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe '#edit' do
    context "not logged in" do
      before { get :edit }
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe '#update' do
    context "not logged in" do
      before { patch :update }
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
