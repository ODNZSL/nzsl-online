require 'rails_helper'

RSpec.describe Admin::PagesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create :user }

  let(:page) { FactoryGirl.create(:page) }
  let(:valid_page_params) do
    { title: 'updated page title' }
  end

  context 'user is signed' do
    before { sign_in user }

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

    describe '#update' do
      before { patch :update, id: page.to_param, page: valid_page_params }
      it { expect(response).to redirect_to(admin_pages_url) }
      it { expect(assigns(:page)).to eq(page) }
      it 'updates the page' do
        page.reload
        expect(page.title).to eq(valid_page_params[:title])
      end
    end
  end

  context 'Not logged in' do
    describe '#index' do
      before { get :index }
      it { expect(response).to have_http_status(302) }
      it { expect(response).not_to render_template(:index) }
    end

    describe '#new' do
      before { get :new }
      it { expect(response).to have_http_status(302) }
      it { expect(response).not_to render_template(:n) }
    end

    describe '#edit' do
      before { get :edit, id: page.to_param }
      it { expect(response).to have_http_status(302) }
      it { expect(response).not_to render_template(:edit) }
    end

    describe '#update' do
      before { patch :update, id: page.to_param, page: valid_page_params }
      it { expect(response).to have_http_status(302) }
    end
  end
end
