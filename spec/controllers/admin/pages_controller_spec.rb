require 'rails_helper'

RSpec.describe Admin::PagesController, type: :controller do
  let(:username) { 'test' }
  let(:password) { 'test' }

  let(:page) { FactoryGirl.create(:page) }
  let(:valid_page_params) do
    { title: "updated page title" }
  end

  before { NZSL_ADMIN_ACCESS[username] = Digest::SHA1.hexdigest(password) }

  context 'when HTTP auth credentials are good' do
    before { basic_auth username, password }

    describe 'GET #index' do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
    end

    describe 'GET #edit' do
      before { get :edit, id: page.to_param }
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:edit) }
    end
  end

  context 'Not logged in' do
    describe '#index' do
      before { get :index }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe '#new' do
      before { get :new }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe '#edit' do
      before { get :edit, id: page.to_param }
      it { expect(response).to have_http_status(:unauthorized) }
    end

    describe '#update' do
      before { patch :update, id: page.to_param, page: valid_page_params }
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  context 'when HTTP Digest auth credentials are invalid' do
    before do
      basic_auth 'alice', 'secret'
      get :index
    end
    it { expect(response).to have_http_status(:unauthorized) }
  end
end
