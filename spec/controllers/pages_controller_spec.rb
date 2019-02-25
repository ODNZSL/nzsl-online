# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  before(:all) do
    Rails.application.load_seed
  end

  describe '#random_sign' do
    before { get :random_sign }

    it 'returns HTTP 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'sets @page to the home page' do
      expect(assigns(:page)).to eq Page.find_by_slug('/')
    end

    it 'assigns @sign to a sign' do
      expect(assigns(:sign)).to be_instance_of(Sign)
    end
  end
end
