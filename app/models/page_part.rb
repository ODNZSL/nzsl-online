class PagePart < ActiveRecord::Base
  belongs_to :page
  
  before_validation :strip_text

  validates :title, :presence => true
  validates :order, :numericality => {:integer_only => true, :allow_nil => true}

  default_scope { order('"page_parts"."order" ASC') }

  def slug
    title.downcase.dasherize
  end

private

  def strip_text
    self.title.strip!
    self.translation_path.strip!
  end

end
