# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin login', type: :feature do
  let(:user) { FactoryBot.create :user }

  context 'log in as admin user' do
    before { login_as(user) }

    it 'views admin path' do
      visit admin_path
      expect(page).to have_text('New Page')
    end
  end
end
