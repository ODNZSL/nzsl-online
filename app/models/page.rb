## A page within our basic CMS
class Page < ActiveRecord::Base
  RESTRICTED_SLUGS = %w(admin signs feedback sign_image images javascripts
                        stylesheets system 500 favicon flowplayer-3 flowplayer
                        robots crossdomain) # top level routes & public dir.

  has_many :page_parts

  before_validation :strip_text, :slug_and_label_from_title

  validates :title, :label, presence: true
  validates :slug, presence: true,
                   uniqueness: true,
                   format: { with: %r{\A(\/|[a-z0-9\-\_]*)\Z} },
                   exclusion: { in: RESTRICTED_SLUGS }

  validates :order, numericality: { integer_only: true, allow_nil: true }

  def self.templates
    # apparently this needs to be defined before the validation
    path = Rails.root.join('app', 'views', 'pages')
    Dir.glob(path.join('[^_]*.html.haml')).map { |t| t[(path.to_s.length + 1)..-11] }.sort
  end

  validates :template, presence: true, inclusion: { in: Page.templates }

  default_scope { order('"pages"."order" ASC') }

  scope :in_nav, -> { where(show_in_nav: true) }

  def path
    return '/' if slug == '/'
    "/#{slug}/"
  end

  def self.find_by_slug(slug)
    return where(slug: '/').first if slug.blank?
    where(slug: slug).first
  end

  def multiple_page_parts?
    page_parts.length > 1
  end

  def first_part
    page_parts.first
  end

  def self.in_nav
    where(show_in_nav: true).where(
      "(SELECT COUNT(*) FROM page_parts where page_id = \"pages\".\"id\") > 0")
  end

  private

  def strip_text
    title.strip!
    slug.strip!
    label.strip!
  end

  def slug_and_label_from_title
    self.slug = title.downcase.gsub(/[^a-z0-9]/, '-') if slug.blank?
    self.label = title if label.blank?
  end
end
