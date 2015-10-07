class SignParser
  VIDEO_EXAMPLES_TOTAL = 4

  def initialize(data)
    @data = data
  end

  def build_sign
    @sign = Sign.new
    return sign if @data.nil?

    @sign.id = @data.value_for_tag('headwordid')

    parse_video
    parse_tags
    parse_booleans
    parse_examples
    @sign
  end

  def parse_video
    @sign.video = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain')}"
    glossmain_slow = @data.value_for_tag('ASSET glossmain_slow')
    @sign.video_slow = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain_slow')}" if glossmain_slow.present?
  end

  def parse_tags
    { age_groups: 'VARIATIONAGE',      gender_groups: 'VARIATIONGENDER',
      hint: 'hint',                    usage: 'usage',
      usage_notes: 'essay',            related_to: 'RELATEDTO',
      gloss_main:    'glossmain',      gloss_secondary: 'glosssecondary',
      gloss_minor:   'glossminor',     gloss_maori:   'glossmaori',
      drawing:       'ASSET picture',  handshape:     'handshape',
      location_name: 'location',       word_classes:  'SECONDARYWORDCLASS',
      inflection:     'INFLECTION'
    }.symbolize_keys.each do |key, tag|
      value = @data.value_for_tag(tag)
      @sign.send("#{key}=", value)
    end
  end

  def parse_booleans
    {
      contains_numbers: 'number_incorp',
      is_fingerspelling: 'fingerspelling',
      is_directional: 'directional',
      is_locatable: 'locatable',
      one_or_two_handed: 'one_or_two_hand'
    }.each do |key, tag|
      value = @data.value_for_tag(tag).to_bool
      @sign.send("#{key}=", value)
    end
  end

  def parse_examples
    # examples
    @sign.examples = []
    VIDEO_EXAMPLES_TOTAL.times do |i|
      next unless @data.value_for_tag("ASSET finalexample#{i}").present?

      if @data.value_for_tag("ASSET finalexample#{i}_slow").present?
        video_slow = "#{ASSET_URL}#{@data.value_for_tag("ASSET finalexample#{i}_slow")}"
      else
        video_slow = nil
      end

      @sign.examples << { transcription: parse_transcription(@data, "videoexample#{i}"),
                          translation: @data.value_for_tag("videoexample#{i}translation"),
                          video: "#{ASSET_URL}#{@data.value_for_tag("ASSET finalexample#{i}")}",
                          video_slow: video_slow
                       }
    end
  end

  def parse_transcription(data, tag)
    transcription = []
    data.css(tag).children.each do |item|
      if item.is_a?(Nokogiri::XML::Text)
        transcription += item.content.split(' ')
      else
        transcription << { id: item['id'], gloss: item.children.first.content }
      end
    end
    transcription
  end
  # Extend Nokogiri with helper method for fetching value
  Nokogiri::XML::Element.class_eval do
    def value_for_tag(tag_name)
      tag = css(tag_name).first
      tag.is_a?(Nokogiri::XML::Node) ? tag.content : ''
    end
  end
end
