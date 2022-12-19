module Signbank
  class SignTopic < Record
    self.table_name = :word_topics
    self.primary_key = nil

    belongs_to :sign, class_name: :"Signbank::Sign",
                      foreign_key: :word_id,
                      inverse_of: :sign_topics

    belongs_to :topic, class_name: :"Signbank::Topic",
                       foreign_key: :topic_name,
                       inverse_of: :sign_topics
  end
end
