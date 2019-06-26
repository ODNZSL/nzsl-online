# frozen_string_literal: true

##
# A "sheet" of items (signs) saved by a user
class VocabSheet < ApplicationRecord
  has_many :items, dependent: :destroy

  def includes_sign?(sign_id)
    items.any? { |i| i.sign_id == sign_id }
  end

  def self.purge_old_sheets
    VocabSheet.where('updated_at < ?', 15.days.ago).destroy_all
  end

  def self.aggressively_purge_old_sheets
    VocabSheet.where('updated_at < ?', 7.days.ago).destroy_all
  end
end
