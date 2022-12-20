module Signbank
  class Asset < Signbank::Record
    self.table_name = :videos
    self.primary_key = nil

    belongs_to :sign, class_name: :"Signbank::Sign", foreign_key: :word_id, inverse_of: :assets
    default_scope -> { order(display_order: :asc) }

    scope :image, -> { where("filename LIKE '%.png'") }
  end
end
