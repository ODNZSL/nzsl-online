class SignParser
  VIDEO_EXAMPLES_TOTAL = 4
  def initialize(data)
    @data = data
  end

  def build_sign
    @sign = Sign.new
    return sign if @data.nil?

    @sign.id = @data.value_for_tag('headwordid')
    @sign.video = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain')}"

    # gloss
    @sign.gloss_main = @data.value_for_tag('glossmain')
    @sign.gloss_secondary = @data.value_for_tag('glosssecondary')
    @sign.gloss_minor = @data.value_for_tag('glossminor')
    @sign.gloss_maori = @data.value_for_tag('glossmaori')

    @sign.video_slow = "#{ASSET_URL}#{@data.value_for_tag('ASSET glossmain_slow')}" if @data.value_for_tag('ASSET glossmain_slow').present?
    @sign.drawing = @data.value_for_tag('ASSET picture')
    @sign.handshape = @data.value_for_tag('handshape')
    @sign.location_name = @data.value_for_tag('location')

    # grammar
    @sign.word_classes = @data.value_for_tag('SECONDARYWORDCLASS')
    @sign.inflection = @data.value_for_tag('INFLECTION')
    @sign.contains_numbers = @data.value_for_tag('number_incorp').to_bool
    @sign.is_fingerspelling = @data.value_for_tag('fingerspelling').to_bool
    @sign.is_directional = @data.value_for_tag('directional').to_bool
    @sign.is_locatable = @data.value_for_tag('locatable').to_bool
    @sign.one_or_two_handed = @data.value_for_tag('one_or_two_hand').to_bool

    # notes
    @sign.age_groups = @data.value_for_tag('VARIATIONAGE')
    @sign.gender_groups = @data.value_for_tag('VARIATIONGENDER')
    @sign.hint = @data.value_for_tag('hint')
    @sign.usage = @data.value_for_tag('usage')
    @sign.usage_notes = @data.value_for_tag('essay')
    @sign.related_to = @data.value_for_tag('RELATEDTO')

    # examples
    @sign.examples = []
    VIDEO_EXAMPLES_TOTAL.times do |i|
      next unless @data.value_for_tag("ASSET finalexample#{i}").present?
      @sign.examples << { transcription: parse_transcription(@data, "videoexample#{i}"),
                         translation: @data.value_for_tag("videoexample#{i}translation"),
                         video: "#{ASSET_URL}#{@data.value_for_tag("ASSET finalexample#{i}")}",
                         video_slow: (@data.value_for_tag("ASSET finalexample#{i}_slow").present? ? "#{ASSET_URL}#{@data.value_for_tag("ASSET finalexample#{i}_slow")}" : nil)
                       }
    end

    @sign
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
