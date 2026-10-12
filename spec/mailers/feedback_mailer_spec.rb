# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackMailer, type: :mailer do
  describe "#email" do
    let(:feedback) { Feedback.create(name: "Name", message: "Message", email: "feedback@example.com") }

    subject(:mail) { described_class.email(feedback) }

    it "has no attachments when no video is attached" do
      expect(mail.attachments).to be_empty
    end

    it "attaches the video when one is attached" do
      feedback.video.attach(
        io: StringIO.new("fake video content"),
        filename: "video.mp4",
        content_type: "video/mp4"
      )

      expect(mail.attachments.map(&:filename)).to contain_exactly("video.mp4")
      expect(mail.attachments.first.body.decoded).to eq("fake video content")
    end
  end
end
