require 'rails_helper'

RSpec.describe Signbank::SignsController, type: :controller, sign_model_adapter: :signbank do
  describe '/' do
    it 'searches by term'
    it 'searches for handshape'
    it 'searches for usage'
    it 'searches for topic'
    it 'searches for location'
    it 'searches for location group'
  end

  describe '/autocomplete' do
    it 'searches by approximate term'
    it 'limits results to 100 records'
    it 'handles a blank term'
  end

  describe '/:id' do
    it 'renders a sign'
    it 'renders 404 with an unknown sign'
  end
end
