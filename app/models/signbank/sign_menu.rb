require 'cgi'

module Signbank
  class SignMenu < Freelex::SignMenu
    TOPIC_TAGS = Topic.pluck(:name, :name).sort.map { |tag| [tag.first, tag.second] }

    def self.topic_tags
      TOPIC_TAGS
    end

    def self.usage_tags
      Sign.distinct.pluck(:usage, :usage).sort
    end
  end
end
