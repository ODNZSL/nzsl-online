# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feedback', type: :model do
  it { is_expected.to have_attribute :name }
  it { is_expected.to have_attribute :message }
  it { is_expected.to have_attribute :video_file_name }
  it { is_expected.to have_attribute :video_file_size }
  it { is_expected.to have_attribute :video_updated_at }
  it { is_expected.to have_attribute :email }
  it { is_expected.to have_attribute :hearing_level }
  it { is_expected.to have_attribute :nzsl_level }
  it { is_expected.to have_attribute :include_sign }
  it { is_expected.to have_attribute :include_describe }
  it { is_expected.to have_attribute :include_define }
  it { is_expected.to have_attribute :include_users }
  it { is_expected.to have_attribute :include_comments }
  it { is_expected.to have_attribute :change_sign }
  it { is_expected.to have_attribute :change_sign_gloss }
  it { is_expected.to have_attribute :change_sign_url }
  it { is_expected.to have_attribute :change_sign_entry }
  it { is_expected.to have_attribute :change_comments }
  it { is_expected.to have_attribute :technical_fault }

  let!(:feedback) { Feedback.create }
  subject { feedback }

  describe '#send_email' do
    subject { super().send_email }
    it 'delegates to Feedbackmailer' do
      expect(FeedbackMailer)
        .to receive_message_chain(:email, :deliver)
        .with(self)
        .with(no_args)
      subject
    end
  end
end
