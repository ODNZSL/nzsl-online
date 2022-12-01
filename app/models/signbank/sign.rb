module Signbank
  class Sign < Record
    self.table_name = :words
    self.primary_key = :id

    with_options foreign_key: :word_id, inverse_of: :sign, dependent: :destroy do |signbank|
      signbank.has_many :assets, class_name: :"Signbank::Asset"
      signbank.has_many :examples, class_name: :"Signbank::Example"
      signbank.has_many :sign_topics, class_name: :"Signbank::SignTopic"
      signbank.has_many :topics, through: :sign_topics, inverse_of: :signs
      signbank.has_one :picture, -> { image }, class_name: :"Signbank::Asset"
    end

    def self.sign_of_the_day
      first
    end

    def self.random
      # Exclude sex & sexuality, obscene
      order('RANDOM()').first
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
    # Signbank locations just have the minor identifier, not the group identifier.
    # Because of this, we just look up locations by their name, not their identifier.
    # This will work so long as location names remain unique.
    def location
      super.gsub(' - ', '.')
    end
  end
end
