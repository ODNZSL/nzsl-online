module SignsHelper
  
  def render_grammar_notes(sign)
    ['contains_numbers', 
     'is_fingerspelling', 
     'is_directional', 
     'is_locatable', 
     'one_or_two_handed', 
     'inflection_temporal', 
     'inflection_plural',
     'inflection_manner_and_degree'].map do |note|
       sign.send(note.to_sym) ? link_to(t("signs.show.field.#{note}"), "/help##{note}") : nil
     end.compact.join(', ').html_safe
  end
  
  def render_transcription(transcription, id)
    transcription.map do |sign| 
      if sign.is_a?(String)
        sign
      elsif sign[:id] == id
        content_tag :strong, sign[:gloss]
      else 
        link_to h(sign[:gloss]), sign_url(sign[:id])
      end
    end.join(' ').html_safe
  end
  
  def render_back_to_search_results
    referer = URI.split(request.referer) #5 is path, 7 is query. why does this method not return a hash?
    return unless search_signs_path == referer[5] 
    link_to t('signs.show.back_to_search_results'), "#{search_signs_path}?#{referer[7]}"
  end
  
  def handshape_image number, main=false
    handshape_location_image 'handshape', number, main
  end
  def location_image number, main=false
    handshape_location_image 'location', number, main
  end
  def handshape_location_image handshape_location, number, main
    classes = 'image ir rounded'
    classes << ' main_image' if main
    if handshape_location == 'handshape'
      value = number
    elsif main
      value = number.split('.')[0]
    else
      value = number.split('.')[1]
    end
    output = content_tag :div, value, {:style => "background-image:url('/images/#{handshape_location}s/#{handshape_location}.#{number.downcase.gsub(/[ \/]/, '_')}.png')", :class => classes}
    output << number.split('.').last if handshape_location == 'location'
    output
  end
end

