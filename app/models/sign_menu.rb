class SignMenu
  def self.handshapes
    [
      [['1.1.1', '1.1.2', '1.1.3'], ['1.2.1', '1.2.2'], ['1.3.1', '1.3.2'], ['1.4.1']],
      [['2.1.1', '2.1.2'], ['2.2.1', '2.2.2'], ['2.3.1', '2.3.2', '2.3.3'], ['8.1.1', '8.1.2', '8.1.3']],
      [['3.1.1'], ['3.2.1'], ['3.3.1'], ['3.4.1', '3.4.2'], ['3.5.1', '3.5.2']],
      [['4.1.1', '4.1.2'], ['4.2.1', '4.2.2'], ['4.3.1', '4.3.2']],
      [['5.1.1', '5.1.2'], ['5.2.1'], ['5.3.1', '5.3.2'], ['5.4.1']],
      [['6.1.1', '6.1.2', '6.1.3', '6.1.4'], ['6.2.1', '6.2.2', '6.2.3', '6.2.4'], ['6.3.1', '6.3.2'],
       ['6.4.1', '6.4.2'], ['6.5.1', '6.5.2'], ['6.6.1', '6.6.2']],
      [['7.1.1', '7.1.2', '7.1.3', '7.1.4'], ['7.2.1'], ['7.3.1', '7.3.2', '7.3.3'], ['7.4.1', '7.4.2']]
    ]
  end

  def self.locations
    [['1.1.In front of body', '2.2.In front of face'],
     ['3.3.Head', '3.4.Top of Head', '3.5.Eyes', '3.6.Nose', '3.7.Ear', '3.8.Cheek', '3.9.Lower Head'],
     ['4.0.Body', '4.10.Neck/Throat', '4.11.Shoulders', '4.12.Chest', '4.13.Abdomen', '4.14.Hips/Pelvis/Groin',
      '4.15.Upper Leg'],
     ['5.0.Arm', '5.16.Upper Arm', '5.17.Elbow', '5.18.Lower Arm'],
     ['6.0.Hand', '6.19.Wrist', '6.20.Fingers/Thumb', '6.21.Palm of Hand', '6.22.Back of Hand', '6.23.Blades of Hand']]
  end

  def self.location_groups
    # The first row and the first of each row.
    SignMenu.locations.map.with_index { |r, i| i.zero? ? r : r[0] }.flatten
  end

  def self.usage_tags
    [['archaic',   1],
     ['neologism', 2],
     ['obscene',   3],
     ['informal',  4],
     ['rare',      5]]
  end

  def self.topic_tags # rubocop:disable Metrics/MethodLength
    [
      ['Actions and activities',                     5],
      ['Animals',                                    7],
      ['Body and appearance',                        9],
      ['Clothes',                                   10],
      ['Colours',                                   11],
      ['Communication and cognition', 6],
      ['Computers', 48],
      ['Countries and cities', 21],
      ['Deaf-related',                              12],
      ['Direction, location and spatial relations', 13],
      ['Education',                                 17],
      ['Emotions',                                  18],
      ['Events and celebrations',                   14],
      ['Family',                                    20],
      ['Food and drink',                            16],
      ['Government and politics',                   22],
      ['Health',                                    23],
      ['House and garden', 8],
      ['Idioms and phrases',                        24],
      ['Language and Linguistics',                  45],
      ['Law and crime',                             25],
      ['Maori culture and concepts',                26],
      ['Materials',                                 27],
      ['Maths',                                     47],
      ['Miscellaneous',                             44],
      ['Money',                                     28],
      ['Nationality and ethnicity', 51],
      ['Nature and environment', 19],
      ['New Zealand place names', 50],
      ['Numbers',                                   29],
      ['People and relationships',                  46],
      ['Places',                                    30],
      ['Play and toys', 49],
      ['Pronouns',                                  31],
      ['Qualities, description and comparison',     33],
      ['Quantity and measure',                      34],
      ['Questions',                                 35],
      ['Religions',                                 32],
      ['Science',                                   38],
      ['Sex and sexuality',                         36],
      ['Sports, recreation and hobbies',            37],
      ['Time',                                      39],
      ['Travel and transportation',                 40],
      ['Weather',                                   41],
      ['Work',                                      42]]
  end
end
