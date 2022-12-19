module SignNotesHelper
  NOTES = %i[
    contains_numbers
    is_fingerspelling
    is_directional
    is_locatable
    one_or_two_handed
    inflection_temporal
    inflection_plural
    inflection_manner_and_degree
  ].freeze

  def render_grammar_notes(sign)
    help_path = Page.find(Setting.get(:glossary)).try(:path)

    note_links = NOTES.map do |note|
      next unless sign.send(note)

      attrs = {
        class: 'js-ga-link-submission',
        onclick: "_gaq.push(['_trackEvent', 'Sign', 'Click', 'glossary #{note}']);"
      }

      link_to(t("signs.show.field.#{note}"), "#{help_path}##{note}", attrs)
    end.compact

    safe_join(note_links, ', ')
  end
end
