module SearchHelper
  
  def handshapes
    [[['1.1.1', '1.1.2', '1.1.3'], ['1.2.1', '1.2.2'], ['1.3.1', '1.3.2'], ['1.4.1']], 
     [['2.1.1', '2.1.2'], ['2.2.1', '2.2.2'], ['2.3.1', '2.3.2', '2.3.3'], ['8.1.1', '8.1.2', '8.1.3']], 
     [['3.1.1'], ['3.2.1'], ['3.3.1'], ['3.4.1', '3.4.2'], ['3.5.1', '3.5.2']], 
     [['4.1.1', '4.1.2'], ['4.2.1', '4.2.2'], ['4.3.1', '4.3.2']], 
     [['5.1.1', '5.1.2'], ['5.2.1'], ['5.3.1', '5.3.2'], ['5.4.1']], 
     [['6.1.1', '6.1.2', '6.1.3', '6.1.4'], ['6.2.1', '6.2.2', '6.2.3', '6.2.4'], ['6.3.1', '6.3.2'], ['6.4.1', '6.4.2'], ['6.5.1', '6.5.2'], ['6.6.1', '6.6.2']], 
     [['7.1.1', '7.1.2', '7.1.3', '7.1.4'], ['7.2.1'], ['7.3.1', '7.3.2', '7.3.3'], ['7.4.1', '7.4.2']]]
  end
  
  def locations
    [['1.1.In front of body', '2.2.In front of face'], 
     ['3.3.Head', '3.4.Top of Head', '3.5.Eyes', '3.6.Nose', '3.7.Ear', '3.8.Cheek', '3.9.Lower Head'], 
     ['4.0.Body', '4.10.Neck/Throat', '4.11.Shoulders', '4.12.Chest', '4.13.Abdomen', '4.14.Hips/Pelvis/Groin', '4.15.Upper Leg'],
     ['5.0.Arm', '5.16.Upper Arm', '5.17.Elbow', '5.18.Lower Arm'], 
     ['6.0.Hand', '6.19.Wrist', '6.20.Fingers/Thumb', '6.21.Palm of Hand', '6.22.Back of Hand', '6.23.Blades of Hand']]
  end
  
  def usage_tags
    [['archaic','1'], ['neologism','2'], ['obscene','3'], ['informal','4'], ['rare','5']]
  end
  def topic_tags
    [['Actions and activities',                    '5' ],
     ['Communication and cognition',               '6' ],
     ['Animals',                                   '7' ],
     ['House and garden',                          '8' ],
     ['Body and appearance',                       '9' ],
     ['Clothes',                                   '10'],
     ['Colours',                                   '11'],
     ['Deaf-related',                              '12'],
     ['Direction, location and spatial relations', '13'],        
     ['Events and celebrations',                   '14'],
     ['Family',                                    '15'],
     ['Food and drink',                            '16'],
     ['Education',                                 '17'],
     ['Emotions',                                  '18'],
     ['Nature and environment',                    '19'],
     ['Family',                                    '20'],
     ['Countries, cities and nationalities',       '21'],  
     ['Government and politics',                   '22'],
     ['Health',                                    '23'],
     ['Idioms and phrases',                        '24'],
     ['Law and crime',                             '25'],
     ['Maori culture and concepts',                '26'],
     ['Materials',                                 '27'],
     ['Money',                                     '28'],
     ['Numbers',                                   '29'],
     ['Places',                                    '30'],
     ['Pronouns',                                  '31'],
     ['Religions',                                 '32'],
     ['Qualities, description and comparison',     '33'],    
     ['Quantity and measure',                      '34'],
     ['Questions',                                 '35'],
     ['Sex and sexuality',                         '36'],
     ['Sports, recreation and hobbies',            '37'],
     ['Science',                                   '38'],
     ['Time',                                      '39'],
     ['Travel and transportation',                 '40'],
     ['Weather',                                   '41'],
     ['Work',                                      '42'],
     ['Miscellaneous',                             '44'],
     ['Language and Linguistics',                  '45'],
     ['People and relationships',                  '46'],
     ['Maths',                                     '47'],
     ['Computers',                                 '48']]
  end
  def location_groups
    locations.map.with_index{|r, i| i.zero? ? r : r[0]}.flatten
  end
  def handshape_image number, main=false
    handshape_location_image 'handshape', number, main
  end
  
  def location_image number, main=false
    handshape_location_image 'location', number, main
  end
  
  def handshape_location_image handshape_location, number, main, add_location_label=true
    classes = 'image ir rounded'
    classes << ' main_image' if main
    if handshape_location == 'handshape'
      if main
        value = number.split('.')[0,2].join('.')
      else
        value = number
      end
    elsif main
      value = number.split('.')[0]
    else
      value = number.split('.')[1]
    end
    output = content_tag :div, value, {:style => "background-image:url('/images/#{handshape_location}s/#{handshape_location}.#{number.downcase.gsub(/[ \/]/, '_')}.png')", :class => classes}
    output << number.split('.').last if handshape_location == 'location' && add_location_label
    output
  end
  
  def handshape_selected?(shape)
    if @query['hs'].present?
      query_hs = @query['hs']
      query_hs = @query['hs'].map {|q| "#{q}.1"} if shape.split('.').last == '1'
      'selected' if query_hs.include?(shape)
    end
  end
  
  def location_selected?(location)
    'selected' if @query['l'].present? && @query['l'].include?(location.split('.')[1])
  end
  def location_group_selected?(location_group)
    'selected' if @query['lg'].present? && @query['lg'].include?(location_group.split('.')[0])
  end
  def selected_tab?(tab)
    'selected' if tab == 'keywords'
  end
  def display_locations_search_term
    locations.flatten.select{|l| location_selected?(l) }.map{|l| handshape_location_image 'location', l, false, false }.join(' ').html_safe unless @query['l'].blank?
  end
  def display_handshapes_search_term
    handshapes.flatten.flatten.select{|hs| handshape_selected?(hs) }.map{|hs| handshape_location_image 'handshape', hs, (hs.split('.').last == '1') }.join(' ').html_safe unless @query['hs'].blank?
  end
  def display_location_groups_search_term
    location_groups.select{|lg| location_group_selected?(lg)}.map{|lg| handshape_location_image 'location', lg, true, false }.join(' ').html_safe unless @query['lg'].blank?
  end
  
  def locations_search_term
    h(@query['l'].join(' ')) unless @query['l'].blank?
  end
  def handshapes_search_term
    h(@query['hs'].join(' ')) unless @query['l'].blank?
  end
  def location_groups_search_term
    h(@query['lg'].join(' ')) unless @query['l'].blank?
  end
  def keywords_search_term
    h(@query['s'].join(' ')) unless @query['s'].blank?
  end
  def usage_tag_search_term
  end
  def topic_tag_search_term
  end 
end