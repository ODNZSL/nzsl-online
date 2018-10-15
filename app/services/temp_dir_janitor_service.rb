class TempDirJanitorService
  def initialize(tmp_dir_path:)
    @tmp_dir_path = tmp_dir_path
  end

  # We will eventually fill the hard disk if we don't clean old files from our
  # temp dir. We consider the file to be "old" enough to delete if it has not
  # been modified in the last hour.
  #
  # This is enough time that we won't clobber a file that another rails
  # thread/process may be in the middle of serving to a different user.
  def remove_old_files
    Dir
      .glob("#{@tmp_dir_path}/**/*")
      .each { |path| FileUtils.rm_rf(path) if old?(path) }
  end

  private

  def old?(path)
    File.mtime(path) < 1.hour.ago
  end
end
