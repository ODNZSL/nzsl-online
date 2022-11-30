# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchQuerySanitizationService do
  subject { described_class.new }

  describe '#sanitize_for_standard_search' do
    it 'returns the expected results for all example search terms' do
      input_output_map = {
        # search-term      => expected-result
        { 's' => nil } => {},
        { 's' => '' } => {},
        { 's' => 'hello' } => { 's' => ['hello'] },
        { 's' => 'hello-world' } => { 's' => ['hello-world'] },
        { 's' => "he!@\#$%^&*()llo" } => { 's' => ['he()llo'] },
        { 's' => ('x' * 1000) } => { 's' => [('x' * described_class::MAX_QUERY_TERM_LENGTH)] },
        { 's' => 'Māori' } => { 's' => ['Māori'] },

        { 'hs' => nil } => {},
        { 'hs' => '' } => {},
        { 'hs' => '1.2 1.2.3 3.4.5' } => { 'hs' => ['1.2', '1.2.3', '3.4.5'] },

        { 'l' => nil } => {},
        { 'l' => '' } => {},
        { 'l' => 'hello' } => {},
        { 'l' => '1hello 2' } => { 'l' => %w[1 2] },
        { 'l' => "1-%\#@!hello 2" } => { 'l' => %w[1 2] },
        { 'l' => '1 2 3' } => { 'l' => %w[1 2 3] },

        { 'lg' => nil } => {},
        { 'lg' => '' } => {},
        { 'lg' => 'helglgo' } => {},
        { 'lg' => '1helglgo 2' } => { 'lg' => %w[1 2] },
        { 'lg' => "1-%\#@!helglgo 2" } => { 'lg' => %w[1 2] },
        { 'lg' => '1 2 3' } => { 'lg' => %w[1 2 3] },

        { 'usage' => nil } => {},
        { 'usage' => '' } => {},
        { 'usage' => 'heusageusageo' } => {},
        { 'usage' => '1heusageusageo 2' } => { 'usage' => ['12'] },
        { 'usage' => "1-%\#@!heusageusageo 2" } => { 'usage' => ['12'] },
        { 'usage' => '1 2 3' } => { 'usage' => ['123'] },

        { 'tag' => nil } => {},
        { 'tag' => '' } => {},
        { 'tag' => 'hetagtago' } => {},
        { 'tag' => '1hetagtago 2' } => { 'tag' => %w[1 2] },
        { 'tag' => "1-%\#@!hetagtago 2" } => { 'tag' => %w[1 2] },
        { 'tag' => '1 2 3' } => { 'tag' => %w[1 2 3] }
      }

      input_output_map.each do |search_term, expected_result|
        expect(subject.sanitize_for_standard_search(search_term)).to eq(expected_result)
      end
    end

    it 'returns an empty string if the given search term is nil' do
      expect(subject.sanitize_for_standard_search(nil)).to eq({})
    end
  end

  describe '#sanitize_for_autocomplete_search' do
    it 'returns the expected results for all example search terms' do
      input_output_map = {
        # search-term      => expected-result
        'hello  12' => 'hello  12', # letters, numbers, spaces
        'hello Māori' => 'hello Māori', # macrons in the middle
        'Ōtara' => 'Ōtara', # macrons at the start
        'hello ' => 'hello', # trailing whitespace removed
        'file%3A%2F%2F%2F' => 'file3A2F2F2F' # malicious
      }

      input_output_map.each do |search_term, expected_result|
        expect(subject.sanitize_for_autocomplete_search(search_term)).to eq(expected_result)
      end
    end

    it 'returns an empty string if the given search term is nil' do
      expect(subject.sanitize_for_autocomplete_search(nil)).to eq('')
    end

    it 'truncates the input if it is too long' do
      long_input = 'X' * 1024
      expected_output = 'X' * described_class::MAX_QUERY_TERM_LENGTH
      expect(subject.sanitize_for_autocomplete_search(long_input)).to eq(expected_output)
    end
  end
end
