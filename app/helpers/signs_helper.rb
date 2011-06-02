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
    case referer[5]
    when search_signs_path
      link_to t('signs.show.back_to.search_results'), "#{search_signs_path}?#{h referer[7]}"
    when '/numbers'
      link_to t('signs.show.back_to.numbers'), '/numbers'
    when '/classifiers'
      link_to t('signs.show.back_to.classifiers'), '/classifiers'
    else
      ''
    end
  end
  
end

