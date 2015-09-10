class Item < ActiveRecord::Base
  validates_presence_of :sign_id, :name
  validates_numericality_of :sign_id
  validates_numericality_of :position, :greater_than => 0, :allow_nil => true

  belongs_to :vocab_sheet

  attr_writer :sign

  def maori_name
    update_maori_name_if_missing
    super
  end

  def update_maori_name_if_missing
    return unless read_attribute(:maori_name).nil? && self.persisted?
    self.maori_name = sign.gloss_maori
    save
  end

  before_validation do
    self.name = (self.sign.is_a?(Sign) ? self.sign.gloss_main : nil) if self.name.nil? or self.name.blank?
    self.maori_name = (self.sign.is_a?(Sign) ? self.sign.gloss_maori : nil) if self.maori_name.nil? or self.maori_name.blank?
    self.sign_id = sign.id if self.sign_id.nil?
    self.drawing = sign.drawing
  end

  default_scope { order('position ASC', 'created_at ASC') }

  def sign
    @sign ||= Sign.first(id: sign_id)
  end
end
