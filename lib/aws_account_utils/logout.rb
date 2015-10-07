require 'aws_account_utils/base'

module AwsAccountUtils
  class Logout < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def execute
      logger.debug "Logging out of AWS."
      browser.goto url
      screenshot(browser, "1")
      browser.wait_until{ browser.url.include? 'https://aws.amazon.com/'}
      browser.text.include?('Sign In to the Console') || browser.text.include?('Create a Free Account')
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      'https://console.aws.amazon.com/support/logout!doLogout'
    end
  end
end
