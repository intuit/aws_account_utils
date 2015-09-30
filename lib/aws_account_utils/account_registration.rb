require 'aws_account_utils/base'

module AwsAccountUtils
  class AccountRegistration < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def signup(account_name, account_email, account_password)
      logger.debug "Signing up for a new account."
      login_details = { 'ap_customer_name'  => account_name,
                        'ap_email'          => account_email,
                        'ap_email_check'    => account_email,
                        'ap_password'       => account_password,
                        'ap_password_check' => account_password }

      browser.goto signup_url
      browser.text_field(:id => 'ap_customer_name').wait_until_present
      screenshot(browser, "1")
      login_details.each do |k,v|
        browser.text_field(:id => k).when_present.set v
      end
      screenshot(browser, "2")
      browser.button(:id => 'continue-input').when_present.click
      raise StandardError if browser.div(:id => /message_(error|warning)/).exist?
      true
    rescue StandardError
      screenshot(browser, "error")
      error_header = browser.div(:id => /message_(error|warning)/).h6.text
      error_body = browser.div(:id => /message_(error|warning)/).p.text
      raise StandardError, "AWS signup error: \"#{error_header}: #{error_body}\""

    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def signup_url
      url =  "https://www.amazon.com/ap/register?"
      url << "&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select"
      url << "&create=1&openid.assoc_handle=aws&accountStatusPolicy=P1"
      url << "&openid.ns=http://specs.openid.net/auth/2.0"
      url << "&openid.identity=http://specs.openid.net/auth/2.0/identifier_select"
      url << "&openid.mode=checkid_setup"
      url << "&openid.return_to=https://console.aws.amazon.com/billing/signup"
    end
  end
end
