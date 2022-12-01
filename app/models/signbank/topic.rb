module Signbank
  class Topic < Signbank::Record
    self.table_name = :topics
    self.primary_key = :name

    has_many :sign_topics,
             foreign_key: :topic_name,
             class_name: :"Signbank::SignTopic",
             dependent: :destroy

    has_many :signs, through: :sign_topics,
                     inverse_of: :topics
  end
end
