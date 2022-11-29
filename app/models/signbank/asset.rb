module Signbank
  class Asset < Signbank::Record
    self.table_name = :videos
    belongs_to :sign, class_name: :"Signbank::Sign"
    default_scope -> { order(display_order: :asc) }

    scope :image, -> { where("filename LIKE '%.png'") }
  end
end
