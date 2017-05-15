## A page within our basic CMS
class Page < ActiveRecord::Base
  RESTRICTED_SLUGS = %w(admin signs feedback sign_image images javascripts
                        stylesheets system 500 favicon flowplayer-3 flowplayer
                        robots crossdomain) # top level routes & public dir.

  has_many :page_parts

  before_validation :slug_and_label_from_title, :strip_text

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
    return find_by(slug: '/') if slug.blank?
    find_by(slug: slug)
  end

  def multiple_page_parts?
    page_parts.length > 1
  end

  def first_part
    page_parts.first
  end

  ##
  # Find pages that should display in navigation
  def self.in_nav
    where(show_in_nav: true).where(
      "(SELECT COUNT(*) FROM page_parts where page_id = \"pages\".\"id\") > 0")
  end

  def self.create_from_csv(row)
    id, title, slug, label, order, template, show_in_nav, created_at, updated_at = row

    Page.where(id: id).first_or_create(
      id: id,
      title: title,
      slug: slug,
      label: label,
      order: order,
      template: template,
      show_in_nav: show_in_nav,
      updated_at: updated_at,
      created_at: created_at
    )
  end

  private

  def strip_text
    title.strip! if title
    slug.strip! if slug
    label.strip! if label
  end

  def slug_and_label_from_title
    self.slug = title.downcase.gsub(/[^a-z0-9]/, '-') if slug.blank?
    self.label = title if label.blank?
  end
end
