require 'rails_helper'

RSpec.describe AutocompleteSearchService do
  describe '#find_suggestions' do
    context 'When the external services behaves as expected' do
      subject do
        described_class.new(search_term: search_term, faraday_connection: stubbed_faraday_connection)
      end

      let(:search_term) { 'Anything' }
      let(:freelex_suggestions) { %w{ad ba bb aa ab ac bc bd} }
      let(:expected_suggestions) { %w{aa ab ac ad ba bb bc bd} }
      let(:stubbed_faraday_connection) do
        Faraday::Connection.new do |faraday|
          faraday.use Faraday::Adapter::Test do |stub|
            stub.get '/' do
              [200, { 'Content-Type' => 'text/plain' }, freelex_suggestions.join("\n")]
            end
          end
        end
      end

      it 'Returns a sorted list of suggestions from Freelex' do
        results = subject.find_suggestions
        expect(results).to eq(expected_suggestions)
      end
    end

    context 'When there is an error communicating with the external search service' do
      subject do
        described_class.new(search_term: search_term,
                            faraday_connection: stubbed_faraday_connection,
                            logger: logger)
      end

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
  end
end
