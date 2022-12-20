module SignExamplesHelper
  def autolink_glosses(sentence, current_sign_id: nil)
    # Sentences have two notation styles that we handle:
    #   * Leading caret is used as an 'escape sequence'. We just strip these, they
    #     are mostly left over from Freelex - e.g. ^hs:, ^fp:. They don't get formatted otherwise.
    #   * Gloss links are notated by non-numeric and non-space characters, followed by
    #     square brackets containing a numeric ID. We turn these into links, unless
    #     it's the current sign, in which case it is not linked, but we display it
    #     as bold.
    sanitize(sentence.tr('^', '').gsub(/(?<gloss>[^\d\s]+)\[(?<id>\d+)\]/) do
      sign = Regexp.last_match.named_captures
      next tag.strong(sign['gloss']) if sign['id'] == current_sign_id

      link_to sign['gloss'],
              sign_url(sign['id']),
              class: 'js-ga-link-submission',
              onclick: "_gaq.push(['_trackEvent', 'Sign', 'Click', 'example #{sign[:id]}']);"
    end)
  end
end
