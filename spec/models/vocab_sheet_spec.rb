# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VocabSheet, type: :model do
  subject { described_class.new(name: 'My Vocab Sheet name') }

  let(:sign_id) { '1234' }
  let(:sign) do
    instance_double('Sign',
                    id: sign_id,
                    gloss_maori: 'Some maori name',
                    gloss_main: 'Some name',
                    drawing: 'foo.jpg')
  end
  let(:item) { Item.new('sign_id' => sign_id) }

  describe '#add_item' do
    before(:each) do
      allow(Sign).to receive(:first).and_return(sign)
    end

    context 'When adding a new item to the VocabSheet' do
      it 'saves the item as expected' do
        expect(subject.items).to eq([])

        subject.add_item(item)

        expect(subject.items.length).to eq(1)
        expect(subject.items.first.id).to eq(item.id)
      end

      it 'saves the VocabSheet' do
        subject.add_item(item)

        expect(subject.persisted?).to eq(true)
      end
    end

    context 'When adding an item which already exists in the VocabSheet' do
      it 'does not save a duplicate item' do
        subject.add_item(item)
        subject.add_item(item)

        expect(subject.items.length).to eq(1)
        expect(subject.items.first.id).to eq(item.id)
      end
    end
  end

  describe '#update_item' do
    before(:each) do
      allow(Sign).to receive(:first).and_return(sign)
    end

    context 'When there is an item in the VocabSheet' do
      it 'updates the attributes as expected' do
        subject.add_item(item)

        new_name = 'new name'
        new_maori_name = 'new maori name'
        new_attrs = {
          'id' => item.id,
          'name' => new_name,
          'maori_name' => new_maori_name
        }

        subject.update_item(new_attrs)

        result = subject.items.first
        expect(result.name).to eq(new_name)
        expect(result.maori_name).to eq(new_maori_name)
      end
    end
  end

  describe '#items' do
    before(:each) do
      allow(Sign).to receive(:first).and_return(sign)
    end

    context 'When there is an item in the VocabSheet' do
      it 'returns them as instances of Item' do
        subject.add_item(item)

        expect(subject.items.length).to eq(1)
        expect(subject.items.first).to be_a(Item)
      end
    end
  end

  describe '#destroy_items' do
    before(:each) do
      allow(Sign).to receive(:first).and_return(sign)
    end

    context 'When there is an item in the VocabSheet' do
      it 'destroys the item and returns it' do
        subject.add_item(item)

        expect(subject.items.length).to eq(1)

        returned_item = subject.destroy_item(item.id)

        expect(subject.items.length).to eq(0)
        expect(returned_item.id).to eq(item.id)
      end
    end
  end

  describe '#reorder_items' do
    let(:sign_2_id) { '4567' }
    let(:sign_2) do
      instance_double('Sign',
                      id: sign_2_id,
                      gloss_maori: 'Some maori name',
                      gloss_main: 'Some name',
                      drawing: 'foo.jpg')
    end
    let(:item_2) { Item.new('sign_id' => sign_2_id) }

    before(:each) do
      allow(Sign).to receive(:first).and_return(sign, sign_2)
    end

    context 'When there is an item in the VocabSheet' do
      it 'reorders the items as expected' do
        original_order = [item.id, item_2.id]
        new_order = [item_2.id, item.id]

        subject.add_item(item)
        subject.add_item(item_2)

        expect(subject.items.map(&:id)).to eq(original_order)

        subject.reorder_items(item_ids: new_order)

        expect(subject.items.map(&:id)).to eq(new_order)
      end
    end
  end
end
