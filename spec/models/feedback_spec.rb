require 'rails_helper'

describe 'Feedback' do
  it 'sends email' do
    expect(FeedbackMailer).to receive(:email)
    feedback = Feedback.create
    feedback.send_email
  end
end
