require 'rails_helper'

RSpec.describe Signbank::Record do
  describe '.database_version' do
    it 'returns the user version of the database' do
      version = 42
      allow(Signbank::Record.connection).to receive(:execute)
        .with('PRAGMA user_version')
        .and_return([{ 'user_version' => version }])

      expect(Signbank::Record.database_version).to eq(version)
    end
  end
end
