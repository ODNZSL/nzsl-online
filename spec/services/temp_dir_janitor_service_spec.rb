# frozen_string_literal: true

require "rails_helper"

RSpec.describe TempDirJanitorService do
  let(:keepable_file) { "keep-me.txt" }
  let(:removable_file) { "remove-me.txt" }

  subject { TempDirJanitorService.new(tmp_dir_path: tmp_dir_path) }

  describe "#remove_old_files" do
    it "removes all files & folders which are older than an hour" do
      Dir.mktmpdir do |tmp_dir|
        # given
        subject = TempDirJanitorService.new(tmp_dir_path: tmp_dir)
        Dir.chdir(tmp_dir) do
          # 'mtime' parameter requires an actual instance if Time, not
          # ActiveSupport::TimeWithZone so we need to call #to_time
          FileUtils.touch(removable_file, mtime: 1.1.hours.ago.to_time) # rubocop:disable Rails/Date
          FileUtils.touch(keepable_file, mtime: 0.9.hours.ago.to_time)  # rubocop:disable Rails/Date
        end

        # when
        subject.remove_old_files

        # then
        Dir.chdir(tmp_dir) do
          expect(File.exist?(keepable_file)).to eq(true)
          expect(File.exist?(removable_file)).to eq(false)
        end
      end
    end
  end
end
