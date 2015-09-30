require 'aws_account_utils/base'

module AwsAccountUtils
  class EmailPreferences < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def opt_out(account_email, account_password)
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      browser.input(:id => 'email_preferences_optout_all_true').when_present.click
      screenshot(browser, "1")
      browser.input(:value => 'Save Changes').when_present.click
      browser.h3(:text => /You have successfully updated your email preferences/).wait_until_present
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      'https://aws.amazon.com/email-preferences/'
    end
  end
end
