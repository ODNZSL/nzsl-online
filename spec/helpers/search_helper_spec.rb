# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchHelper, type: :helper do
  describe '#classes_for_sign_attribute' do
    context 'when provided with a true value for main' do
      it 'returns the main_image class as part of the response string' do
        classes = helper.send(:classes_for_sign_attribute, :location, true)
        expect(classes.split(' ')).to include('image', 'rounded', 'main_image')
      end
    end

    context 'when provided with an :handshape attribute' do
      it 'returns the transition class as part of the response string' do
        classes = helper.send(:classes_for_sign_attribute, :handshape, false)
        expect(classes.split(' ')).to include('image', 'rounded', 'transition')
      end
    end

    context 'when provided with a false value for main and a attribute not matching :handshape' do
      it 'returns the default class string' do
        classes = helper.send(:classes_for_sign_attribute, nil, false)
        expect(classes.split(' ')).to include('image', 'rounded')
      end
    end
  end
end
