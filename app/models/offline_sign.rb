class OfflineSign < ApplicationRecord
  establish_connection :offline
  self.table_name = :words

  ID_REGEXP = %r{\A#{Regexp.escape(ASSET_URL)}(\d{4})/}.freeze

  alias_attribute :gloss_main, :gloss
  alias_attribute :gloss_maori, :maori
  alias_attribute :gloss_secondary, :minor

  delegate :age_groups, :borrowed_from, :contains_numbers, :gender_groups, :hint, :inflection,
           :inflection_manner_and_degree, :inflection_plural, :inflection_temporal, :is_directional,
           :is_fingerspelling, :is_locatable, :one_or_two_handed, :related_to, :usage, :usage_notes,
           :video_slow, :word_classes,
           to: :no_op, allow_nil: true

  def id
    video[ID_REGEXP, 1]
  end

  def self.find_by_id!(id)
    # We don't have an ID, just a video with a known structure
    where('video LIKE :url_prefix', url_prefix: "#{ASSET_URL}#{id}/%").first!
  end

  def no_op
    nil
  end

  def examples
    []
  end

  # @return [String] if we find the location
  # @return [nil] otherwise
  def location
    SignMenu.locations.flatten.find { |l| l.split('.')[2].downcase[0, 4] == super[0, 4] }
  end

  def drawing_url
    "/images/signs/#{id}/#{picture}"
  end
end
