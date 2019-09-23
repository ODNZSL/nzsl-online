# frozen_string_literal: true

class SignMenu # rubocop:disable Metrics/ClassLength
  HANDSHAPES = [
    [
      ['1.1.1', '1.1.2', '1.1.3'].freeze,
      ['1.2.1', '1.2.2'].freeze,
      ['1.3.1', '1.3.2'].freeze,
      ['1.4.1'].freeze
    ].freeze,
    [
      ['2.1.1', '2.1.2'].freeze,
      ['2.2.1', '2.2.2'].freeze,
      ['2.3.1', '2.3.2', '2.3.3'].freeze,
      ['8.1.1', '8.1.2', '8.1.3'].freeze
    ].freeze,
    [
      ['3.1.1'].freeze,
      ['3.2.1'].freeze,
      ['3.3.1'].freeze,
      ['3.4.1', '3.4.2'].freeze,
      ['3.5.1', '3.5.2'].freeze
    ].freeze,
    [
      ['4.1.1', '4.1.2'].freeze,
      ['4.2.1', '4.2.2'].freeze,
      ['4.3.1', '4.3.2'].freeze
    ].freeze,
    [
      ['5.1.1', '5.1.2'].freeze,
      ['5.2.1'].freeze,
      ['5.3.1', '5.3.2'].freeze,
      ['5.4.1'].freeze
    ].freeze,
    [
      ['6.1.1', '6.1.2', '6.1.3', '6.1.4'].freeze,
      ['6.2.1', '6.2.2', '6.2.3', '6.2.4'].freeze,
      ['6.3.1', '6.3.2'].freeze,
      ['6.4.1', '6.4.2'].freeze,
      ['6.5.1', '6.5.2'].freeze,
      ['6.6.1', '6.6.2'].freeze
    ].freeze,
    [
      ['7.1.1', '7.1.2', '7.1.3', '7.1.4'].freeze,
      ['7.2.1'].freeze,
      ['7.3.1', '7.3.2', '7.3.3'].freeze,
      ['7.4.1', '7.4.2'].freeze
    ].freeze
  ].freeze

  LOCACTIONS = [
    ['1.1.In front of body', '2.2.In front of face'].freeze,
    ['3.3.Head', '3.4.Top of Head', '3.5.Eyes', '3.6.Nose', '3.7.Ear', '3.8.Cheek', '3.9.Lower Head'].freeze,
    ['4.0.Body', '4.10.Neck/Throat', '4.11.Shoulders', '4.12.Chest', '4.13.Abdomen', '4.14.Hips/Pelvis/Groin', '4.15.Upper Leg'].freeze, # rubocop:disable Metrics/LineLength
    ['5.0.Arm', '5.16.Upper Arm', '5.17.Elbow', '5.18.Lower Arm'].freeze,
    ['6.0.Hand', '6.19.Wrist', '6.20.Fingers/Thumb', '6.21.Palm of Hand', '6.22.Back of Hand', '6.23.Blades of Hand'].freeze # rubocop:disable Metrics/LineLength
  ].freeze

  LOCATION_GROUPS = [
    '1.1.In front of body',
    '2.2.In front of face',
    '3.3.Head',
    '4.0.Body',
    '5.0.Arm',
    '6.0.Hand'
  ].freeze

  USAGE_TAGS = [
    ['archaic',   1].freeze,
    ['informal',  4].freeze,
    ['neologism', 2].freeze,
    ['obscene',   3].freeze,
    ['rare',      5].freeze
  ].freeze

  TOPIC_TAGS = [
    ['Actions and activities',                    5].freeze,
    ['Animals',                                   7].freeze,
    ['Body and appearance',                       9].freeze,
    ['Clothes',                                   10].freeze,
    ['Colours',                                   11].freeze,
    ['Communication and cognition',               6].freeze,
    ['Computers',                                 48].freeze,
    ['Countries and cities',                      21].freeze,
    ['Deaf-related',                              12].freeze,
    ['Direction, location and spatial relations', 13].freeze,
    ['Education',                                 17].freeze,
    ['Emotions',                                  18].freeze,
    ['Events and celebrations',                   14].freeze,
    ['Family',                                    20].freeze,
    ['Food and drink',                            16].freeze,
    ['Government and politics',                   22].freeze,
    ['Health',                                    23].freeze,
    ['House and garden',                          8].freeze,
    ['Idioms and phrases',                        24].freeze,
    ['Language and Linguistics',                  45].freeze,
    ['Law and crime',                             25].freeze,
    ['Maori culture and concepts',                26].freeze,
    ['Materials',                                 27].freeze,
    ['Maths',                                     47].freeze,
    ['Miscellaneous',                             44].freeze,
    ['Money',                                     28].freeze,
    ['Nationality and ethnicity',                 51].freeze,
    ['Nature and environment',                    19].freeze,
    ['New Zealand place names',                   50].freeze,
    ['Numbers',                                   29].freeze,
    ['People and relationships',                  46].freeze,
    ['Places',                                    30].freeze,
    ['Play and toys',                             49].freeze,
    ['Pronouns',                                  31].freeze,
    ['Qualities, description and comparison',     33].freeze,
    ['Quantity and measure',                      34].freeze,
    ['Questions',                                 35].freeze,
    ['Religions',                                 32].freeze,
    ['Science',                                   38].freeze,
    ['Sex and sexuality',                         36].freeze,
    ['Sports, recreation and hobbies',            37].freeze,
    ['Time',                                      39].freeze,
    ['Travel and transportation',                 40].freeze,
    ['Weather',                                   41].freeze,
    ['Work',                                      42].freeze
  ].freeze

  def self.handshapes
    HANDSHAPES
  end

  def self.locations
    LOCACTIONS
  end

  def self.location_groups
    LOCATION_GROUPS
  end

  def self.usage_tags
    USAGE_TAGS
  end

  def self.topic_tags
    TOPIC_TAGS
  end
end
