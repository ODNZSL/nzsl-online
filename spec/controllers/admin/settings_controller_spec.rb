require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create :user }

  let!(:setting) { FactoryGirl.create(:setting) }
  let(:valid_params) { { setting.key => 'newvalue' } }

  context 'user is signed' do
    before { sign_in user }

    describe 'GET #index' do
      before { get :index }
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to render_template(:index) }
    end

    describe 'GET #edit' do
      before { get :edit }
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

  context 'user it not signed in' do
    describe '#index' do
      before { get :index }
      it { expect(response).to have_http_status(302) }
      it { expect(response).not_to render_template(:index) }
    end

    describe '#edit' do
      before { get :edit }
      it { expect(response).to have_http_status(302) }
      it { expect(response).not_to render_template(:edit) }
    end

    describe '#update' do
      before { patch :update }
      it { expect(response).to have_http_status(302) }
    end
  end
end
