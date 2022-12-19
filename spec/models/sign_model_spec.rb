require 'rails_helper'

RSpec.describe SignModel, type: :model do
  describe '.resolve' do
    subject { described_class.resolve }

    it "resolves Freelex::Sign when the adapter is 'freelex'", sign_model_adapter: :freelex do
      expect(subject).to eq Freelex::Sign
    end
    it "resolves Signbank::Sign when the adapter is 'signbank'", sign_model_adapter: :signbank do
      expect(subject).to eq Signbank::Sign
    end
  end
end
