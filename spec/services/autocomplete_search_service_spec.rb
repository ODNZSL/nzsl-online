require 'rails_helper'

RSpec.describe AutocompleteSearchService do
  describe '#find_suggestions' do
    context 'When the external services behaves as expected' do
      let(:search_term) { 'Anything' }
      let(:expected_suggestions) { %w{1 2 3 4 5 6 7 8 9 10} }
      let(:stubbed_faraday_connection) do
        Faraday::Connection.new do |faraday|
          faraday.use Faraday::Adapter::Test do |stub|
            stub.get '/' do
              [200, { 'Content-Type' => 'text/plain' }, expected_suggestions.join("\n")]
            end
          end
        end
      end

      subject do
        described_class.new(search_term: search_term, faraday_connection: stubbed_faraday_connection)
      end

      it 'Returns the expected suggestions' do
        results = subject.find_suggestions
        expect(results).to eq(expected_suggestions)
      end
    end

    context 'When there is an error communicating with the external search service' do
      let(:search_term) { 'Anything' }
      let(:expected_suggestions) { %w{1 2 3 4 5 6 7 8 9 10} }
      let(:stubbed_faraday_connection) do
        Faraday::Connection.new do |faraday|
          faraday.use Faraday::Adapter::Test do |stub|
            stub.get '/' do
              raise(Faraday::Error, 'Simulated autocomplete service failure')
            end
          end
        end
      end
      let(:log_accumulator) { '' }
      let(:logger) do
        Logger.new(StringIO.new(log_accumulator))
      end

      subject do
        described_class.new(search_term: search_term,
                                      faraday_connection: stubbed_faraday_connection,
                                      logger: logger)
      end

      it 'Recovers from the error by returning an empty result-set' do
        results = subject.find_suggestions
        expect(results).to eq([])
      end

      it 'Sends an explanatory error to Raygun' do
        expect(Raygun).to receive(:track_exception)
        subject.find_suggestions
      end

      it 'Logs an explanatory message' do
        subject.find_suggestions
        expect(log_accumulator).to include('Recovered from failed autocomplete search')
      end
    end

    context 'When it receives more than the requested number of results' do
      let(:search_term) { 'Anything' }
      let(:all_suggestions) { %w{1 2 3 4 5 6 7 8 9 10 11 12} }
      let(:expected_suggestions) { %w{1 2 3 4 5 6 7 8 9 10} }
      let(:stubbed_faraday_connection) do
        Faraday::Connection.new do |faraday|
          faraday.use Faraday::Adapter::Test do |stub|
            stub.get '/' do
              [200, { 'Content-Type' => 'text/plain' }, all_suggestions.join("\n")]
            end
          end
        end
      end

      subject do
        described_class.new(search_term: search_term, faraday_connection: stubbed_faraday_connection)
      end

      it 'Discards extra results' do
        results = subject.find_suggestions
        expect(results).to eq(expected_suggestions)
      end
    end
  end
end
