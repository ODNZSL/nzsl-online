##
# A "sheet" of items (signs) saved by a user
class VocabSheet < ActiveRecord::Base
  has_many :items
end
