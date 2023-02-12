require 'rails_helper'

RSpec.describe 'Signbank: Sign features', type: :system do
  before { Rails.application.load_seed }

  it 'can search for signs', js: true do
    # Term
    visit root_path
    within '.search_form' do
      fill_in 'Search by English or Māori keywords', with: 'Dictionary'
      click_on 'Search'
    end
    expect(page).to have_current_path(search_signs_path, ignore_query: true)
    expect(page).to have_content 'search results for Dictionary'
    expect(page).to have_selector '.search-results__card', count: 2

    # Handshape
    visit root_path
    within '.search_form' do
      click_on 'Advanced Search Options'
      find('.advanced-search-button div.default', text: 'Hand Shape').click
      find('.attribute_options .value + img', match: :first).click
      click_on 'Search'
    end

    expect(page).to have_current_path(search_signs_path, ignore_query: true)
    expect(page).to have_selector '.search-results__card', minimum: 1

    # Location
    visit root_path
    within '.search_form' do
      click_on 'Advanced Search Options'
      find('.advanced-search-button div.default', text: 'Body Location').click
      find('.attribute_options .value + img', match: :first).click
      click_on 'Search'
    end

    expect(page).to have_current_path(search_signs_path, ignore_query: true)
    expect(page).to have_selector '.search-results__card', minimum: 1

    # Usage
    visit root_path
    within '.search_form' do
      click_on 'Advanced Search Options'
      find('.advanced-search-button div.default', text: 'Usage').click
      find('.usage-dropdown', text: 'archaic').click
      click_on 'Search'
    end

    expect(page).to have_current_path(search_signs_path, ignore_query: true)
    expect(page).to have_content 'search results for archaic'
    expect(page).to have_selector '.search-results__card', minimum: 1

    # Topic
    visit root_path
    within '.search_form' do
      click_on 'Advanced Search Options'
      find('.advanced-search-button div.default', text: 'Topic').click
      find('.topic-dropdown', text: 'Animals').click
      click_on 'Search'
    end

    expect(page).to have_current_path(search_signs_path, ignore_query: true)
    expect(page).to have_content 'search results for Animals'
    expect(page).to have_selector '.search-results__card', minimum: 1
  end

  it 'can view a sign' do
    sign = Signbank::Sign.find('1301')
    visit sign_path(sign)
    Percy.snapshot(page, name: 'signs#show')
    expect(page).to have_selector '.search-result-banner > h1', text: sign.gloss
    expect(page).to have_selector '.main_gloss', text: sign.gloss
    expect(page).to have_selector '.secondary_gloss', text: sign.minor
    expect(page).to have_selector '.maori-gloss', text: sign.maori
    expect(page).to have_selector 'video.main_video'
    expect(page).to have_link 'Download Drawing'
    expect(page).to have_link 'Add to Vocab Sheet'
  end

  it 'can view a sign when the sign is missing a drawing' do
    sign = Signbank::Sign.find('1301').dup
    sign.id = SecureRandom.uuid # New ID, no picture
    sign.save!
    visit sign_path(sign)
    expect(page).to have_selector '.main_gloss', text: sign.gloss
    expect(page).not_to have_link 'Download drawing'
    expect(page).to have_link 'Add to Vocab Sheet'
    expect(page).to have_selector "img.main-image[src='']"
  end

  it "can see a 'sign of the day'" do
    visit root_path
    within '.sign-of-the-day' do
      expect(page).to have_content('Sign of the day')
      # We don't know what the gloss will be ahead of time, but we know the link
      # href to expect
      expect(page).to have_link(href: %r{/signs/\d+$})
    end
  end

  it 'can request a random sign' do
    visit root_path
    sign_link_matcher = %r{/signs/\d+$}

    sign_link = page.find_link(href: sign_link_matcher, match: :first)
    sign_href_a = sign_link['href']

    click_on 'Show me another sign'
    sign_link = page.find_link(href: sign_link_matcher, match: :first)
    sign_href_b = sign_link['href']

    expect(sign_href_a).not_to eq sign_href_b
  end

  it 'can add signbank signs to a vocab sheet', js: true do
    sign = Signbank::Sign.find('1301')
    visit sign_path(sign)
    click_on 'Add to Vocab Sheet'
    expect(page).to have_content 'Sign added'
    within '.vocab-sheet__item' do
      expect(page).to have_content(sign.gloss)
      find('.remove').click
    end

    expect(page).to have_content 'Sign removed'
  end
end
