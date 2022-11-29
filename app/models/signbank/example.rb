module Signbank
  class Example < Signbank::Record
    self.table_name = :examples

    belongs_to :sign, class_name: :"Signbank::Sign"
    default_scope -> { order(display_order: :asc).where.not(video: nil) }
  end
end
