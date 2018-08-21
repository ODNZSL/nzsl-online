# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin login', type: :feature do
  let!(:pages) { FactoryBot.create_list :page, 10 }
  subject { page }

  context 'not logged in' do
    describe 'views pages#index' do
      before { visit admin_pages_path }
      it { is_expected.to have_text 'Forgot your password?'}
    end
  end

  context 'log in as admin user' do
    let(:user) { FactoryBot.create :user }
    before { login_as(user) }

    describe 'views pages#index' do
      before { visit admin_pages_path }
      it { is_expected.to have_text 'Pages' }
      it { is_expected.to have_link 'New Page' }
      it { is_expected.to have_text pages.first.label}
    end
  end
end
