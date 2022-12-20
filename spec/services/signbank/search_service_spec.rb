require 'rails_helper'

RSpec.describe Signbank::SignSearchService, type: :service do
  it 'searches by term' do
    signs = []
    # Deliberately out of order so we can check they are ordered by relevance
    signs << maori_gloss = make_sign(maori_normalized: 'Test gloss')
    signs << maori_partial_gloss = make_sign(maori_normalized: 'Partial gloss')
    signs << main_gloss = make_sign(gloss_normalized: 'Test gloss')
    signs << main_partial_gloss = make_sign(gloss_normalized: 'Partial gloss')
    signs << minor_gloss = make_sign(minor_normalized: 'Test gloss')
    signs << minor_partial_gloss = make_sign(minor_normalized: 'Partial gloss')
    relation = Signbank::Sign.where(id: signs.map(&:id))
    results = described_class.new(s: %w[gloss], relation: relation).results

    expect(results.count).to eq 6
    expect(results).to eq [
      main_gloss,
      main_partial_gloss,
      minor_gloss,
      minor_partial_gloss,
      maori_gloss,
      maori_partial_gloss
    ]
  end

  it 'only matches terms on whole words' do
    sign = make_sign(gloss_normalized: 'Testword')
    relation = Signbank::Sign.where(id: sign.id)
    expect(described_class.new(s: %w[Testw], relation: relation).results.count).to eq 0
    expect(described_class.new(s: %w[Testwordz], relation: relation).results.count).to eq 0
    expect(described_class.new(s: %w[Testword], relation: relation).results.count).to eq 1
  end

  it 'searches by multiple OR handshapes' do
    signs = []
    signs << handshape_match_1 = make_sign(handshape: '1.1.1')
    signs << handshape_match_2 = make_sign(handshape: '1.1.2')
    signs << make_sign(handshape: '1.2.1') # This should not match
    relation = Signbank::Sign.where(id: signs.map(&:id))

    searches = {
      { hs: %w[1.1.1] } => [handshape_match_1],
      { hs: %w[1.1] } => [handshape_match_1, handshape_match_2],
      { hs: %w[1.1.1 1.1.2] } => [handshape_match_1, handshape_match_2],
      { hs: %w[1.1.3] } => []
    }

    searches.each do |query, expected_results|
      expect(described_class.new(query, relation: relation).results).to eq expected_results
    end
  end

  it 'searches by multiple OR location groups' do
    signs = []
    signs << location_match_1 = make_sign(location_identifier: '04 - top of head')
    signs << location_match_2 = make_sign(location_identifier: '10 - neck/throat')
    signs << make_sign(location_identifier: '16 - upper arm')
    relation = Signbank::Sign.where(id: signs.map(&:id))

    searches = {
      { lg: %w[3 4] } => [location_match_1, location_match_2],
      { lg: %w[3] } => [location_match_1],
      { lg: %w[4] } => [location_match_2]
    }

    searches.each do |query, expected_results|
      expect(described_class.new(query, relation: relation).results).to eq expected_results
    end
  end

  it 'searches by multiple OR locations' do
    signs = []
    signs << location_match_1 = make_sign(location_identifier: '04 - top of head')
    signs << location_match_2 = make_sign(location_identifier: '10 - neck/throat')
    signs << make_sign(location_identifier: '16 - upper arm')
    relation = Signbank::Sign.where(id: signs.map(&:id))

    searches = {
      { l: %w[4 10] } => [location_match_1, location_match_2],
      { l: %w[4] } => [location_match_1],
      { l: %w[10] } => [location_match_2]
    }

    searches.each do |query, expected_results|
      expect(described_class.new(query, relation: relation).results).to eq expected_results
    end
  end

  it 'combines multiple locations and location groups' do
    signs = []
    signs << location_match_1 = make_sign(location_identifier: '04 - top of head')
    signs << location_match_2 = make_sign(location_identifier: '10 - neck/throat')
    signs << location_match_3 = make_sign(location_identifier: '16 - upper arm')
    signs << make_sign(location_identifier: '20 - fingers/thumb')
    relation = Signbank::Sign.where(id: signs.map(&:id))

    query = { lg: %w[3 4], l: %w[16] }
    expected_results = [location_match_1, location_match_2, location_match_3]
    expect(described_class.new(query, relation: relation).results).to eq expected_results
  end

  it 'searches by usage' do
    sign = make_sign(usage: 'archaic')
    unmatched_sign = make_sign(usage: 'informal')
    relation = Signbank::Sign.where(id: [sign, unmatched_sign].map(&:id))

    expect(described_class.new({ usage: ['archaic'] }, relation: relation).results).to eq [sign]
  end

  it 'searches by topic' do
    topic = Signbank::Topic.all.sample
    another_topic = Signbank::Topic.where.not(name: topic.name).sample
    sign = make_sign(topics: [topic])
    unmatched_sign = make_sign(topics: [another_topic])
    relation = Signbank::Sign.where(id: [sign, unmatched_sign].map(&:id))

    expect(described_class.new({ tag: [topic.name] }, relation: relation).results).to eq [sign]
  end

  private

  def make_sign(attrs = {})
    Signbank::Sign.create!(id: SecureRandom.uuid, **attrs)
  end
end
