module Signbank
  class Example < Signbank::Record
    self.table_name = :examples
    self.primary_key = nil

    belongs_to :sign, class_name: :"Signbank::Sign",
                      foreign_key: :word_id,
                      inverse_of: :examples
    default_scope -> { order(display_order: :asc).where.not(video: nil) }
  end
end
