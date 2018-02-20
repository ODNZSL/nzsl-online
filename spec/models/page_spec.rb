# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page', type: :model do
  subject { page }

  let!(:page) do
    FactoryBot.build(:page,
                     title: 'Automated testing rocks',
                     slug: 'so-true',
                     label: 'Test all the things',
                     template: 'standard')
  end

  it { is_expected.to have_attribute :title }
  it { is_expected.to have_attribute :slug }
  it { is_expected.to have_attribute :label }
  it { is_expected.to have_attribute :order }
  it { is_expected.to have_attribute :template }
  it { is_expected.to have_attribute :show_in_nav }




  describe 'validations' do
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

    it 'cleans up whitespace' do
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

      page.save!
      expect(page.slug.blank?).to eq(false)
    end

    it 'slug needs to be unique' do
      subject.save
      expect do
        Page.new(title: 'title',
                 slug: 'so-true',
                 label: 'Test all the things',
                 template: 'standard').save!
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'populates slug and label with title if they are blank' do
      page = Page.new(title: 'title',
                      template: 'standard')

      page.save!

      expect(page.slug).to eq 'title'
      expect(page.label).to eq 'title'
    end
  end

  describe '.find_by_slug' do
    it 'finds by slug' do
      subject.save!
      found_page = Page.find_by_slug('so-true')
      expect(found_page).to eq(subject)
    end
  end

  describe '.in_nav' do
    it 'finds the pages that must show in footer nav' do
      pages = Page.in_nav
      expect(pages.length).to eq(0)

      page.show_in_nav = true
      page.page_parts = [PagePart.new(title: 'part of a page')]
      subject.save!

      # retrieve the pages that should show in nav
      pages = Page.in_nav
      expect(pages.length).to eq(1)
    end
  end

  describe '.in_header_nav' do
    it 'finds the pages that must show in header nav' do
      pages = Page.in_header_nav
      expect(pages.length).to eq(0)

      page.show_in_nav = true
      page.slug = 'topics'
      subject.save!

      # retrieve the pages that should show in nav
      pages = Page.in_header_nav
      expect(pages.length).to eq(1)
    end
  end

  describe '.create_from_csv!' do
    context 'when the page exists in the database' do
      let(:row) do
        [page.id, 'Automated testing rocks', 'help', 'help', 23, 'standard',
         true, page.created_at, page.updated_at]
      end

      it 'updates the record' do
        subject.save!
        Page.create_from_csv!(row)
        updated_page = Page.find_by(id: page.id)
        expect(updated_page.slug).to eq 'help'
      end
    end

    context 'when the page does not yet exist in the database' do
      let(:row) { [155, 'this bites!', 'help', 'help', 23, 'standard', true, page.created_at, page.updated_at] }

      it 'creates the record' do
        subject.save!
        expect(Page.all.length).to eq 1
        Page.create_from_csv!(row)
        expect(Page.all.length).to eq 2
      end
    end
  end

  describe '#path' do
    it 'works out path' do
      expect(subject.path).to eq('/so-true/')
    end
  end

  describe '#multiple_page_parts?' do
    let(:page_part1) { PagePart.new(title: 'part of a page') }
    let(:page_part2) { PagePart.new(title: 'other part of a page') }

    it 'determines the page does not have multiple parts' do
      expect(subject.multiple_page_parts?).to eq(false)
    end

    it 'determines the page has multiple parts' do
      page.page_parts = [page_part1, page_part2]
      subject.save!
      expect(subject.multiple_page_parts?).to eq(true)
    end
  end

  describe '#first_part' do
    let(:page_part1) { PagePart.new(title: 'part of a page') }
    let(:page_part2) { PagePart.new(title: 'other part of a page') }

    before do
      page.page_parts = [page_part1, page_part2]
    end

    it 'determines the first part of the page' do
      subject.save!
      expect(subject.first_part).to eq(page_part1)
    end
  end
end
