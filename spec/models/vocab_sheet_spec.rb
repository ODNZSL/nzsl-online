require 'rails_helper'

RSpec.describe 'VocabSheet', type: :model do
  describe '#clear_vocab_sheet' do
    it 'only deletes a vocab sheet older than 31 days' do
      FactoryBot.create_list(:vocab_sheet, 5)
      vocab_sheet = FactoryBot.create(:vocab_sheet, created_at: 1.year.ago, updated_at: 1.year.ago)
      FactoryBot.create_list(:item, 3, vocab_sheet_id: vocab_sheet.id)

      expect(Item.count).to eq 3
      VocabSheet.clear_vocab_sheet
      expect(VocabSheet.count).to eq 5
      expect(Item.count).to eq 0
    end
  end
end
