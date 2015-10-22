class Item < ActiveRecord::Base
  validates :sign_id, :name, presence: true
  validates :sign_id, :position, numericality: true
  # validates :position, greater_than: 0, allow_nil: true

  belongs_to :vocab_sheet

  attr_writer :sign

  def maori_name
    update_maori_name_if_missing
    super
  end

  def update_maori_name_if_missing
    return unless self[:maori_name].nil? && self.persisted?
    self.maori_name = sign.gloss_maori
    save
  end

  before_validation do
    self.name = (sign.is_a?(Sign) ? sign.gloss_main : nil) if name.nil? || name.blank?
    self.maori_name = (sign.is_a?(Sign) ? sign.gloss_maori : nil) if maori_name.nil? || maori_name.blank?
    self.sign_id = sign.id if sign_id.nil?
    self.drawing = sign.drawing
  end

  default_scope { order('position ASC', 'created_at ASC') }

  def sign
    @sign ||= Sign.first(id: sign_id)
  end
end
