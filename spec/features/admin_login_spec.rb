# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin login', type: :feature do
  let(:user) { FactoryBot.create :user }

  context 'log in as admin user' do
    background { login_as(user) }

    scenario 'views admin path' do
      visit admin_path
      expect(page).to have_text('New Page')
    end
  end
end
