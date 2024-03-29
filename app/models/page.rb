# frozen_string_literal: true

## A page within our basic CMS
class Page < ApplicationRecord
  RESTRICTED_SLUGS = %w[admin signs feedback sign_image images javascripts
                        stylesheets system 500 favicon
                        robots crossdomain].freeze # top level routes & public dir.

  HEADER_NAV = %w[topics alphabet numbers classifiers].freeze

  has_many :page_parts, dependent: :destroy

  before_validation :slug_and_label_from_title, :strip_text

  validates :title, :label, presence: true
  validates :slug, presence: true,
                   uniqueness: true,
                   format: { with: %r{\A(/|[a-z0-9\-_]*)\Z} },
                   exclusion: { in: RESTRICTED_SLUGS }

  validates :order, numericality: { integer_only: true, allow_nil: true }

  def self.templates
    # apparently this needs to be defined before the validation
    path = Rails.root.join('app', 'views', 'pages')
    Dir.glob(path.join('[^_]*.html.haml')).pluck((path.to_s.length + 1)..-11).sort
  end

  validates :template, presence: true, inclusion: { in: Page.templates }

  default_scope { order(order: :asc) }

  scope :in_nav, -> { where(show_in_nav: true) }

  def self.find_by_slug(slug)
    return find_by(slug: '/') if slug.blank?

    find_by(slug:)
  end

  ##
  # Find pages that should display in footer navigation
  def self.in_nav
    where(show_in_nav: true).where(
      '(SELECT COUNT(*) FROM page_parts where page_id = "pages"."id") > 0'
    )
  end

  ##
  # Find pages that should display in header navigation
  def self.in_header_nav
    where(show_in_nav: true).where(slug: HEADER_NAV)
  end

  def self.create_from_csv!(row)
    id, title, slug, label, order, template, show_in_nav, created_at, updated_at = row

    page = Page.where(id:).first_or_initialize
    page.update!(
      title:,
      slug:,
      label:,
      order:,
      template:,
      show_in_nav:,
      updated_at:,
      created_at:
    )
    page
  end

  def path
    return '/' if slug == '/'

    "/#{slug}/"
  end

  def multiple_page_parts?
    page_parts.length > 1
  end

  def first_part
    page_parts.first
  end

  private

  def strip_text
    title&.strip!
    slug&.strip!
    label&.strip!
  end

  def slug_and_label_from_title
    self.slug = title.downcase.gsub(/[^a-z0-9]/, '-') if slug.blank?
    self.label = title if label.blank?
  end
end
