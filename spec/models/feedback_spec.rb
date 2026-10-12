# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedback", type: :model do
  subject { feedback }

  let!(:feedback) { Feedback.create }

  it { is_expected.to have_attribute :name }
  it { is_expected.to have_attribute :message }
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

  describe "video attachment" do
    let!(:feedback) { Feedback.create(name: "Name", message: "Message") }

    it "is valid without a video" do
      expect(feedback).to be_valid
    end

    it "is invalid when the video exceeds 50 megabytes" do
      feedback.video.attach(
        io: StringIO.new("x"),
        filename: "video.mp4",
        content_type: "video/mp4"
      )
      allow(feedback.video.blob).to receive(:byte_size).and_return(51.megabytes)

      expect(feedback).not_to be_valid
      expect(feedback.errors[:video]).to include("is too large")
    end
  end

  describe "#send_email" do
    subject { super().send_email }

    it "delegates to Feedbackmailer" do
      expect(FeedbackMailer)
        .to receive_message_chain(:email, :deliver)
        .with(self)
        .with(no_args)
      subject
    end
  end
end
