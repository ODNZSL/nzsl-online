require 'rails_helper'

RSpec.describe SignMenu, type: :model do
  describe '.resolve' do
    subject { described_class.resolve }

    it "resolves Freelex::SignMenu when the adapter is 'freelex'", sign_model_adapter: :freelex do
      expect(subject).to eq Freelex::SignMenu
    end
    it "resolves Signbank::SignMenu when the adapter is 'signbank'", sign_model_adapter: :signbank do
      expect(subject).to eq Signbank::SignMenu
    end
  end
end
