class SignParser
  VIDEO_EXAMPLES_TOTAL = 4
  def initialize(data)
    @data = data
  end

  def build_sign
    @sign = Sign.new
    return sign if @data.nil?

    @sign.id = @data.value_for_tag('headwordid')

    parse_gloss
    parse_video
    parse_images
    parse_grammar
    parse_extras
    parse_examples

    @sign
  end

  def parse_gloss
    # gloss
    @sign.gloss_main = @data.value_for_tag('glossmain')
    @sign.gloss_secondary = @data.value_for_tag('glosssecondary')
    @sign.gloss_minor = @data.value_for_tag('glossminor')
    @sign.gloss_maori = @data.value_for_tag('glossmaori')
  end

  def parse_video
    @sign.video = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain')}"
    @sign.video_slow = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain_slow')}" if @data.value_for_tag('ASSET glossmain_slow').present?
  end

  def parse_images
    @sign.drawing = @data.value_for_tag('ASSET picture')
    @sign.handshape = @data.value_for_tag('handshape')
    @sign.location_name = @data.value_for_tag('location')
  end

  def parse_grammar
    # grammar
    @sign.word_classes = @data.value_for_tag('SECONDARYWORDCLASS')
    @sign.inflection = @data.value_for_tag('INFLECTION')

    @sign.contains_numbers = @data.value_for_tag('number_incorp').to_bool
    @sign.is_fingerspelling = @data.value_for_tag('fingerspelling').to_bool
    @sign.is_directional = @data.value_for_tag('directional').to_bool
    @sign.is_locatable = @data.value_for_tag('locatable').to_bool
    @sign.one_or_two_handed = @data.value_for_tag('one_or_two_hand').to_bool
  end

  def parse_extras
    # notes
    @sign.age_groups = @data.value_for_tag('VARIATIONAGE')
    @sign.gender_groups = @data.value_for_tag('VARIATIONGENDER')
    @sign.hint = @data.value_for_tag('hint')
    @sign.usage = @data.value_for_tag('usage')
    @sign.usage_notes = @data.value_for_tag('essay')
    @sign.related_to = @data.value_for_tag('RELATEDTO')
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
