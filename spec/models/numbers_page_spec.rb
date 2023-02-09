require 'rails_helper'

RSpec.describe NumbersPage, type: :model do
  subject(:page) { described_class.new }

  context 'using Freelex', sign_model_adapter: :freelex do
    %w[CARDINAL ORDINAL MONEY TIME AGE FRACTIONAL].each do |category|
      it "contains the expected #{category} signs" do
        collection = described_class.const_get("#{category}_NUMBER_SIGN_IDS")
        method = category.split('_', 1).first.downcase

        expect(page.public_send("#{method}_numbers").map(&:id)).to eq collection
      end
    end
  end

  context 'using Signbank', sign_model_adapter: :signbank do
    %w[CARDINAL ORDINAL MONEY TIME AGE FRACTIONAL].each do |category|
      it "contains the expected #{category} signs" do
        collection = described_class.const_get("#{category}_NUMBER_SIGN_IDS")
        method = category.split('_', 1).first.downcase

        expect(page.public_send("#{method}_numbers").map(&:id)).to eq collection
      end
    end
  end
end
