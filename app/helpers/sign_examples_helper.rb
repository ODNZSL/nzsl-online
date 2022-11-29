module SignExamplesHelper
  def render_transcription(transcription, sign_id)
    transcription_links = transcription.map do |sign|
      if sign.is_a?(String)
        sign
      elsif sign[:id] == sign_id
        tag.strong sign[:gloss]
      else
        link_to h(sign[:gloss]),
                sign_url(sign[:id]),
                class: 'js-ga-link-submission',
                onclick: "_gaq.push(['_trackEvent', 'Sign', 'Click', 'example #{sign[:id]}']);"
      end
    end

    safe_join(transcription_links, ' ')
  end
end
