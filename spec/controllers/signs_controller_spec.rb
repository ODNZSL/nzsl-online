require 'rails_helper'

RSpec.describe SignsController, type: :controller do
  describe '/' do
    before { Rails.application.load_seed }
    render_views

    it 'searches by term' do
      get :search, params: { s: 'Auckland' }
      expect(response).to be_ok
      expect(response.body).to include 'search results for Auckland'
    end

    it 'searches for handshape' do
      get :search, params: { hs: '1.1;;1.2.2' }
      expect(response).to be_ok
      expect(response.body).to match %r{search results for .+/handshape\.1\.1\.1.+/handshape\.1\.2\.2.+}
    end

    it 'searches for usage' do
      get :search, params: { usage: 'archaic' }
      expect(response).to be_ok
      expect(response.body).to include 'search results for archaic'
    end

    it 'searches for topic' do
      get :search, params: { tag: 'Animals' }
      expect(response).to be_ok
      expect(response.body).to include 'search results for Animals'
    end

    it 'searches for location' do
      get :search, params: { l: '4;;5' }
      expect(response).to be_ok
      expect(response.body).to match %r{search results for .+/location\.\d\.4\..+/location\.\d\.5\..+}
    end

    it 'searches for location group' do
      get :search, params: { lg: '1;;2' }
      expect(response).to be_ok
      expect(response.body).to match %r{search results for .+/location\.1\.\d\..+/location\.2\.\d\..+}
    end
  end

  describe '/autocomplete' do
    it 'searches by approximate term' do
      get :autocomplete, params: { term: 'Dictionary' }
      expect(JSON.parse(response.body)).to eq %w[dictionary library]
    end

    it 'limits results to 100 records' do
      gloss = 'testrecord'
      101.times { Signbank::Sign.create!(gloss_normalized: gloss, id: SecureRandom.uuid) }
      get :autocomplete, params: { term: gloss }
      expect(JSON.parse(response.body).size).to eq 100
    end

    it 'handles a blank term' do
      get :autocomplete, params: { term: '' }
      expect(response).to be_ok
      expect(response.body).to be_empty
    end
  end

  describe '/:id' do
    before { Rails.application.load_seed }
    render_views

    it 'renders a sign' do
      sign = Signbank::Sign.order('RANDOM()').first
      get :show, params: { id: sign.id }
      expect(response).to be_ok
      expect(response.body).to include sign.gloss
    end

    it 'renders 404 with an unknown sign' do
      expect { get :show, params: { id: 404_404 } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
