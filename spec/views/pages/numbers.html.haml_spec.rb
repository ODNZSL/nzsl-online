require 'rails_helper'

RSpec.describe 'pages/numbers', type: :view, sign_model_adapter: :signbank do
  it 'renders the expected page title' do
    expect(render).to have_selector('h1', text: 'Numbers')
  end

  it 'renders a button to play the page content in NZSL' do
    expect(render).to have_link 'Play this page in NZSL'
  end

  it 'has the expected section headings' do
    rendered = Capybara.string(render)
    section_headings = rendered.all('.typography > h2')
    expect(section_headings.size).to be > 1
    section_headings.each do |heading|
      expect(rendered).to have_link(heading.text, href: "##{heading['id']}")
    end
  end

  it 'has the expected signs' do
    rendered = render
    numbers_page = NumbersPage.new
    categories = numbers_page.public_methods(false)
    expected_signs = categories.flat_map { |category_method| numbers_page.public_send(category_method) }

    expected_signs.each do |sign|
      expect(rendered).to have_link(href: sign_path(sign.id))
      expect(rendered).to have_selector("img[src='#{sign.picture_url}']")
      expect(rendered).to have_content(sign.gloss_main)
    end
  end
end
