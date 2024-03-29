# frozen_string_literal: true

## Part of a page, in our basic as CMS
class PagePart < ApplicationRecord
  belongs_to :page

  before_validation :strip_text

  validates :title, presence: true
  validates :order, numericality: { integer_only: true, allow_nil: true }

  default_scope { order(order: :asc) }

  def slug
    title.downcase.dasherize
  end

  def self.create_from_csv!(row)
    id, title, order, body, translation_path, page_id, created_at, updated_at = row

    page_part = PagePart.where(id:).first_or_initialize
    page_part.update!(
      title:,
      order:,
      body:,
      translation_path:,
      page_id:,
      created_at:,
      updated_at:
    )
    page_part
  end

  private

  def strip_text
    title.strip!
    translation_path&.strip!
  end
end
