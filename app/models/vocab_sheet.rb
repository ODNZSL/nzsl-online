# frozen_string_literal: true

##
# A "sheet" of items (signs) saved by a user
class VocabSheet < ApplicationRecord
  has_many :items, dependent: :destroy

  def includes_sign?(sign_id)
    items.any? { |i| i.sign_id == sign_id }
  end

  def self.purge_old_sheets
    max_days = 31
    VocabSheet.where('updated_at < ?', max_days.days.ago).destroy_all
  end
end
