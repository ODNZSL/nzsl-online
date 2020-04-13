# frozen_string_literal: true

module SignsHelper
  def render_grammar_notes(sign)
    %i[contains_numbers
       is_fingerspelling
       is_directional
       is_locatable
       one_or_two_handed
       inflection_temporal
       inflection_plural
       inflection_manner_and_degree].map do |note|
      next unless sign.send(note)

      attrs = { class: 'js-ga-link-submission',
                onclick: "_gaq.push(['_trackEvent',
                'Sign', 'Click', 'glossary #{note}']);" }
      link_to(t("signs.show.field.#{note}"),
              "#{Page.find(Setting.get(:glossary)).try(:path)}##{note}", attrs)
    end.compact.join(', ').html_safe
  end

  ##
  # This function should be the one and only place in the app which generates
  # URLs to sign images.
  #
  def sign_image_url(image_name: '', width: 400, height: 400, high_res: false)
    file_name = if high_res
                  image_name.gsub(/default.png$/i, 'high_resolution.png')
                else
                  image_name
                end

    "/images/signs/#{width}-#{height}/#{file_name}"
  end

  def render_transcription(transcription, id)
    transcription.map do |sign|
      if sign.is_a?(String)
        sign
      elsif sign[:id] == id
        content_tag :strong, sign[:gloss]
      else
        link_to h(sign[:gloss]),
                sign_url(sign[:id]),
                class: 'js-ga-link-submission',
                onclick: "_gaq.push(['_trackEvent', 'Sign', 'Click', 'example #{sign[:id]}']);"
      end
    end.join(' ').html_safe
  end

  def render_back_to_search_results
    return unless request.referer

    referer = URI(request.referer)
    case referer.path
    when search_signs_path
      link_to t('signs.show.back_to.search_results'),
              "#{search_signs_path}?#{h referer.query}",
              class: 'back_to_search_results'
    when '/numbers'
      link_to t('signs.show.back_to.numbers'), '/numbers', class: 'back_to_search_results'
    when '/classifiers'
      link_to t('signs.show.back_to.classifiers'), '/classifiers', class: 'back_to_search_results'
    when '/'
      link_to t('signs.show.back_to.home'), '/', class: 'back_to_search_results'
    else
      ''
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
