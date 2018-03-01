# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { item }

  let!(:item) { FactoryBot.create(:item) }

  it { is_expected.to have_attribute :sign_id }
  it { is_expected.to have_attribute :vocab_sheet_id }
  it { is_expected.to have_attribute :name }
  it { is_expected.to have_attribute :position }
  it { is_expected.to have_attribute :drawing }
  it { is_expected.to have_attribute :maori_name }




  describe '#maori_name' do
    subject { super().maori_name }

    context 'when the maori_name field is not nil' do
      it 'returns the maori_name' do
        expect(subject).to eq 'tena koe'
      end
    end

    context 'when the maori_name field is nil' do
      before do
        item.maori_name = nil
        item.save
      end

      it 'returns the sign.gloss_maori' do
        expect(subject).to eq 'ngoikore'
      end
    end
  end
end
