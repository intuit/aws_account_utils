module AwsAccountUtils
  class Login < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def execute(url, aws_email, password)
      browser.goto url
      return true unless login_page?
      logger.debug "Logging into AWS."
      screenshot(browser, "1")
      browser.text_field(:id => 'ap_email').when_present.set aws_email
      browser.text_field(:id => 'ap_password').when_present.set password
      screenshot(browser, "2")
      browser.button(:id => 'signInSubmit-input').when_present.click
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def login_page?
      browser.url.include? 'ap/signin?'
    end
  end
end
