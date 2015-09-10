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

  it 'determines page does not multiple parts' do
    expect(valid_page.multiple_page_parts?).to eq(false)
  end

  it 'finds the pages that must show in nav' do
    pages = Page.in_nav
    expect(pages.length).to eq(0)

    page = Page.new(title: 'extra white space',
                    template: 'standard',
                    show_in_nav: true,
                    page_parts: [PagePart.new(title: 'part of a page')]
                   )
    page.save!

    # retrieve the pages that should show in nav
    pages = Page.in_nav
    expect(pages.length).to eq(1)
  end

  it 'calculates slug and label from title' do
    page = Page.new(title: 'calculate the slug and title please',
                    template: 'standard')
    page.save
    expect(page.slug).to eq('calculate-the-slug-and-title-please')
    expect(page.label).to eq('calculate the slug and title please')
  end
end
