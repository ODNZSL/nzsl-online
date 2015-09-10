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

  private

  def strip_text
    title.strip!
    translation_path.strip! if translation_path
  end
end
