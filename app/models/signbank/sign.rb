module Signbank
  class Sign < Record
    self.table_name = :words
    self.primary_key = :id

    has_many :assets, class_name: :"Signbank::Asset", inverse_of: :sign, dependent: :destroy, foreign_key: :word_id
    has_one :picture,
            -> { where(video_type: :main).where("filename LIKE '%.png'") },
            foreign_key: :word_id,
            class_name: :"Signbank::Asset",
            inverse_of: :sign

    def self.sign_of_the_day
      first
    end

    def self.random
      order('RANDOM()').first
    end

    def self.fetch_by_id_via_cache(id)
      find(id)
    end

    def picture_url
      picture&.url
    end

    ##
    # These are all aliases for the object shape that
    # existing code is expecting
    { gloss_main: :gloss,
      gloss_secondary: :minor,
      gloss_maori: :maori,
      drawing: :picture,
      borrowed_from: :related_to }.each do |(from, to)|
      alias_attribute from, to
    end

    ##
    # Examples aren't in the exported database.
    # Need to consider whether we continue wacking columns in, or whether
    # we try and map examples (I'd prefer this).
    def examples
      []
    end

    ##
    # Signbank locations just have the minor identifier, not the group identifier.
    # We can approximate this by replacing slashes with underscores and looking up
    # using ends_with, but need to think about how to map these neatly.
    def location
      super.gsub(' - ', '.')
    end
  end
end
