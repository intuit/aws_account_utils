require 'aws_account_utils/base'
require 'aws_account_utils/login'

module AwsAccountUtils
  class Account < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def close(account_email, account_password)
      logger.debug "Setting email preferences."

      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password

      browser.checkbox(:ng_model =>'isClosingAccount').when_present.set
      screenshot(browser, "3")

      browser.button(:text => /Close Account/).when_present.click
      screenshot(browser, "2")

      browser.wait_until{ browser.text.include? 'Are you sure you want to close your account?'}
      browser.span(:text => /Close Account/).when_present.click
      screenshot(browser, "3")

      browser.p(:text => /Are you sure you want to close your account?/).wait_while_present

      browser.wait_until{ browser.text.include? 'Account has been closed'}

    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      'https://console.aws.amazon.com/billing/home?#/account'
    end
  end
end