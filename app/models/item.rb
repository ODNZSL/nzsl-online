class Item < ActiveRecord::Base

  validates_presence_of :sign_id, :name
  validates_numericality_of :sign_id

  belongs_to :vocab_sheet

  attr_writer :sign

  before_validation do
    self.name = sign.gloss_main if item.name.nil? or item.name.blank?
    self.sign_id = sign.id if item.sign_id.nil?
  do

  def sign
    @sign ||= Sign.first({:id => self.sign_id})
  end


end

