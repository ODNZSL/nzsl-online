require 'rails_helper'

RSpec.describe 'User Feedback', type: :system do
  before(:all) do
    # These tests require the seed data to be present
    Rails.application.load_seed
  end

  after(:all) do
    # Truncate the DB to remove any seed data we added in the before(:all) hook
    DatabaseCleaner.clean_with :truncation
  end

  it 'submits the feedback form if all required fields are present', js: true do
    visit page_path(slug: 'contact-us')

    fill_in 'Name', with: "Miles Edward O'Brien"
    fill_in 'Email', with: 'milesobrien@transporter-rm3.enterprise'
    fill_in 'Message', with: 'Anybody there?'

    click_on 'Send Feedback'

    expect(page).to have_text('Your feedback has been sent')
  end

  it 'Shows an error if required fields are missing', js: true do
    visit page_path(slug: 'contact-us')

    fill_in 'Name', with: "Miles Edward O'Brien"
    fill_in 'Email', with: 'milesobrien@transporter-rm3.enterprise'
    # we deliberately forget to fill in the "Message" field

    click_on 'Send Feedback'

    expect(page).to have_text("Your feedback didn't send")
  end

  it 'Shows an error if an exception was raised while processing feedback', js: true do
    # Deliberately break the Feedback model (for the duration of this test) so
    # it will raise an error during creation of an instance
    allow(Feedback).to receive(:create).and_raise(RuntimeError)

    visit page_path(slug: 'contact-us')

    fill_in 'Name', with: "Miles Edward O'Brien"
    fill_in 'Email', with: 'milesobrien@transporter-rm3.enterprise'
    fill_in 'Message', with: 'Anybody there?'

    click_on 'Send Feedback'

    expect(page).to have_text("Your feedback didn't send")
  end
end
