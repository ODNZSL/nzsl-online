# frozen_string_literal: true

class Item
  include ActiveModel::Model

  UPDATABLE_ATTRIBUTES = %w{name maori_name notes}.freeze

  validates :sign_id, :name, presence: true

  attr_accessor :id,
                :sign_id,
                :drawing,
                :name,
                :notes,
                :maori_name

  def initialize(attrs = {})
    raise 'Item requires a sign_id to be initialized correctly' if attrs['sign_id'].nil?

    super

    sign = Signbank::Sign.find(sign_id)
    return if sign.nil?

    self.id         = sign.id          if id.nil?
    self.name       = sign.gloss_main  if name.nil?
    self.maori_name = sign.gloss_maori if maori_name.nil?
    self.drawing    = sign.picture_url
  end

  def to_param
    id
  end
end
