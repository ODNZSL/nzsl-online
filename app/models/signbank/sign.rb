module Signbank
  class Sign < Record
    self.table_name = :words
    self.primary_key = :id

    ##
    # Exclude signs that either have the 'obscene' usage flag, or belong to the
    # topic 'Sex and sexuality'. This filter is used in places where we feature
    # signs the 'random sign' feature, and 'sign of the day', where it could be
    # inappropriate to show such signs. We use HAVING here with a simple scoring
    # algorithm, since SQLite does not support the EVERY operator. HAVING
    # operates on a set of rows grouped by the word ID. If any of the rows in
    # the groups contains the topic 'Sex and sexuality', we add 1 to the sum,
    # otherwise we add 99. If the resulting number isn't divisible by 99, we
    # know that at least one row contained 'Sex and Sexuality', and so should be
    # excluded.
    def self.safe_for_work
      left_outer_joins(:topics)
        .where("usage IS NULL OR usage != 'obscene'")
        .group(:id)
        .having <<~SQL.squish
          SUM(
            CASE WHEN word_topics.topic_name IS NOT NULL
                 AND word_topics.topic_name = 'Sex and sexuality'
            THEN 1 ELSE 99 END
          ) % 99 = 0
        SQL
    end

    with_options foreign_key: :word_id, inverse_of: :sign, dependent: :destroy do
      has_many :assets, class_name: :"Signbank::Asset"
      has_many :examples, class_name: :"Signbank::Example"
      has_many :sign_topics, class_name: :"Signbank::SignTopic"
      has_many :topics, through: :sign_topics, inverse_of: :signs
      has_one :picture, -> { image }, class_name: :"Signbank::Asset"
    end

    def self.random
      safe_for_work.order('RANDOM()').first
    end

    def picture_url
      picture&.url
    end

    def video
      return unless super

      AssetURL.new(super).url.to_s
    end

    ##
    # These are all aliases for the object shape that
    # existing code is expecting
    { gloss_main: :gloss,
      gloss_secondary: :minor,
      gloss_maori: :maori,
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
