class Item < ActiveRecord::Base

  validates_presence_of :sign_id, :name
  validates_numericality_of :sign_id
  validates_numericality_of :position, :greater_than => 0, :allow_nil => true

  belongs_to :vocab_sheet

  attr_writer :sign

  before_validation do
    self.name = (self.sign.is_a?(Sign) ? self.sign.gloss_main : nil) if self.name.nil? or self.name.blank?
    self.sign_id = sign.id if self.sign_id.nil?
    self.drawing = sign.drawing
  end

  default_scope order("position ASC", "created_at ASC")


  def sign
    @sign ||= Sign.first({:id => self.sign_id})
  end
  
end

