require 'aws_account_utils/base'
require 'aws_account_utils/login'

module AwsAccountUtils
  class IamBilling < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def enable(account_email, account_password)
      logger.debug "Enabling IAM User Access to Billing Information"
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      browser.a(:xpath => '//a[@ng-click="toggleEditingIAMPreferencesInfoState()"]').when_present(timeout = 120).click
      browser.label(:xpath => '//label[@ng-show="isEditingIAMPreferencesInfo"]').when_present.click
      screenshot(browser, "1")
      browser.button(:xpath => '//button[@ng-click="updateIAMPreferences()"]').when_present.click
      browser.strong(:text => /IAM user access to billing information is activated./).wait_until_present
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      'https://portal.aws.amazon.com/gp/aws/manageYourAccount'
    end
  end
end
