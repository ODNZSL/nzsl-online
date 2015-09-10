require 'spec_helper'

describe 'Page' do
  let(:valid_page) do
    Page.new(title: 'Automated testing rocks',
             slug: 'so-true',
             label: 'Test all the things',
             template: 'standard')
  end
  it 'works out path' do
    expect(valid_page.path).to eq('/so-true/')
  end

  it 'finds by slug' do
    # make sure it is saved before trying to find it
    valid_page.save!

    found_page = Page.find_by_slug('so-true')
    expect(found_page).to eq(valid_page)
  end

  describe 'validation' do
    it 'requires a title' do
      expect do
        Page.new(slug: 'so-true',
                 label: 'Test all the things',
                 template: 'standard').save!
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'requires a label' do
      expect do
        Page.new(title: 'Automated testing rocks',
                 slug: 'so-true',
                 template: 'standard').save!
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'requires a label' do
      expect do
        Page.new(title: 'Automated testing rocks',
                 slug: 'so-true',
                 template: 'standard').save!
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'validates template is in our list' do
      expect do
        Page.new(title: 'Automated testing rocks',
                 slug: 'so-true',
                 label: 'Test all the things',
                 template: 'Made up').save!
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'cleans up whitespate' do
      page = Page.new(title: '  extra white space   ',
                      slug: 'so-true',
                      label: "\n    Test all the things\r",
                      template: 'standard')
      page.save!

      expect(page.title).to eq('extra white space')
      expect(page.label).to eq('Test all the things')
    end

    it 'checks slug is valid' do
      page = Page.new(title: 'extra white space',
                      slug: '   so-true', # leading white space
                      label: 'Test all the things',
                      template: 'standard')
      expect do
        page.save!
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

#   it 'determines if page has multiple parts' do
#   	pending
#   # def multiple_page_parts?
#     # page_parts.length > 1
#   end

#   it 'finds the first part of the page' do
#   	pending
#   # def first_part
#     # page_parts.first
#   end

#   it 'does soemthing with in nav ???' do
#   	pending
#   # def self.in_nav
#     # where(show_in_nav: true).where(
#       # "(SELECT COUNT(*) FROM page_parts where page_id = \"pages\".\"id\") > 0")
#   end

#   it 'removes extra text from titles, slugs, labels'
# 	pending
#   # def strip_text
#     # title.strip!
#     # slug.strip!
#     # label.strip!
#   end

#   it 'calculates slug and label from title' do
#   	pending
#   # def slug_and_label_from_title
#     # self.slug = title.downcase.gsub(/[^a-z0-9]/, '-') if slug.blank?
#     # self.label = title if label.blank?
#   end

end
