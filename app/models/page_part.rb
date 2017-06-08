## Part of a page, in our basic as CMS
class PagePart < ActiveRecord::Base
  belongs_to :page

  before_validation :strip_text

  validates :title, presence: true
  validates :order, numericality: { integer_only: true, allow_nil: true }

  default_scope { order('"page_parts"."order" ASC') }

  def slug
    title.downcase.dasherize
  end

  def self.create_from_csv!(row)
    id, title, order, body, translation_path, page_id, created_at, updated_at = row

    page_part = PagePart.where(id: id).first_or_initialize
    page_part.update!(
      title: title,
      order: order,
      body: body,
      translation_path: translation_path,
      page_id: page_id,
      created_at: created_at,
      updated_at: updated_at
    )
    page_part
  end

  private

  def strip_text
    title.strip!
    translation_path.strip! if translation_path
  end
end
