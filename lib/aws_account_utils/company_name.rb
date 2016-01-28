require 'aws_account_utils/base'
require 'aws_account_utils/login'

module AwsAccountUtils
  class CompanyName < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def set(account_email, account_password, company_name)
      logger.debug "Updating Company Name details."
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      browser.a(:xpath => '//a[@ng-click="toggleEditingContactInfoState()"]').when_present.click
      browser.input(:xpath => '//input[@ng-model="address.company"]').to_subtype.set(company_name)
      # screenshot(browser, "1")
      browser.button(:xpath => '//button[@ng-click="updateContactInformation()"]').when_present.click
      browser.div(:xpath => '//div[@ng-show="options.status == \'success\'"]').wait_until_present
      true
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
