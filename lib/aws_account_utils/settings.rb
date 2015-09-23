module Settings

  def self.set_screenshot_dir(directory)
    @screenshot_dir = directory
  end

  def self.screenshot_dir
    @screenshot_dir
  end
end
