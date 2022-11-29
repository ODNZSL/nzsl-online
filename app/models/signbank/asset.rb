class Signbank::Asset < Signbank::Record
  self.table_name = :videos
  belongs_to :sign, class_name: :"Signbank::Sign"
  default_scope -> { order(display_order: :asc) }
end
