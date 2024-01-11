require 'rails_helper'

RSpec.describe 'shared/_footer.html.erb' do
  it 'renders the database version when available' do
    allow(Signbank::Record).to receive(:database_version).and_return(123_456)
    render partial: 'shared/footer', locals: { last: false }
    expect(rendered).to include 'Database version 123456'
  end

  it 'does not render the database version if it is unavailable' do
    allow(Signbank::Record).to receive(:database_version).and_return(nil)
    render partial: 'shared/footer', locals: { last: false }
    expect(rendered).not_to include 'Database version 123456'
  end
end
