# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe '#random_sign' do
    before do
      FactoryBot.create(:page, slug: '/')

      get(:random_sign)
    end

    it 'returns HTTP 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'sets @page to the home page' do
      expect(assigns(:page)).to eq Page.find_by(slug: '/')
    end

    it 'assigns @sign to a sign' do
      expect(assigns(:sign)).to be_instance_of(Sign)
    end
  end
end
