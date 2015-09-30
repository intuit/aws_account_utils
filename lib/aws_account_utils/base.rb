module AwsAccountUtils
  class Base

    def screenshot(browser, file)
      return unless Settings.screenshot_dir
      calling_method = /(?<=`)(.*)(?=')/.match(caller.first).to_s.gsub(" ",'-')
      calling_class = self.class.to_s.gsub("::",'_')
      browser.screenshot.save screenshot_file(file, calling_class, calling_method)
    end

    private
    def increment(path)
      _, filename, count, extension = *path.match(/(\A.*?)(?:_#(\d+))?(\.[^.]*)?\Z/)
      count = (count || '0').to_i + 1
      "#{filename}_##{count}#{extension}"
    end

    def screenshot_file(file, calling_class, calling_method)
      file_path = File.join Settings.screenshot_dir, "#{calling_class}_#{calling_method}_#{file}_#1.png"
      File.exists?(file_path) ? increment(file_path) : file_path
    end

  end
end


