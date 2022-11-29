module SignExamplesHelper
  def autolink_glosses(sentence, current_sign_id: nil)
    sanitize(sentence.gsub(/(?<gloss>[^\d\s]+)\[(?<id>\d+)\]/) do
      sign = Regexp.last_match.named_captures
      next tag.strong(sign['gloss']) if sign['id'] == current_sign_id

      link_to sign['gloss'],
              sign_url(sign['id']),
              class: 'js-ga-link-submission',
              onclick: "_gaq.push(['_trackEvent', 'Sign', 'Click', 'example #{sign[:id]}']);"
    end)
  end
end
