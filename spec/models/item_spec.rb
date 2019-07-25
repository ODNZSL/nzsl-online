# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:sign_id) { '1234' }
  let(:name) { 'Some name' }
  let(:maori_name) { 'Some maori name' }
  let(:drawing) { 'foo.jpg' }
  let(:sign) { instance_double('Sign', id: sign_id, gloss_maori: maori_name, gloss_main: name, drawing: drawing) }

  subject { Item.new('sign_id' => sign_id) }

  before(:each) do
    allow(Sign).to receive(:first).and_return(sign)
  end

  describe '.new' do
    it 'Initializes successfully given just a sign_id' do
      item = Item.new('sign_id' => sign_id)
      expect(item.valid?).to eq(true)

      expect(item.name).to eq(name)
      expect(item.maori_name).to eq(maori_name)
      expect(item.drawing).to eq(drawing)
    end

    it 'Respects the attributes given and does not overwrite them from the Sign' do
      attr_name = 'my name'
      attr_maori_name = 'my maori name'
      attr_drawing = 'my.jpg'

      attrs = {
        'sign_id' => sign_id,
        'drawing' => attr_drawing,
        'name' => attr_name,
        'maori_name' => attr_maori_name
      }

      item = Item.new(attrs)
      expect(item.valid?).to eq(true)

      expect(item.name).to eq(attr_name)
      expect(item.maori_name).to eq(attr_maori_name)
      expect(item.drawing).to eq(attr_drawing)
    end
  end

  describe '#to_param' do
    it 'returns the sign_id' do
      item = Item.new('sign_id' => sign_id)
      expect(item.to_param).to eq(sign_id)
    end
  end
end
