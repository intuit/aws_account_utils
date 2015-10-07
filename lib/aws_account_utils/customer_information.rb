require 'aws_account_utils/base'
require 'aws_account_utils/login'

module AwsAccountUtils
  class CustomerInformation < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def submit(account_email, account_password, customer_details)
      logger.debug "Entering customer details."
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      browser.link(:text => /AWS Customer Agreement/).wait_until_present
      browser.select_list(:class =>'control-select ng-pristine ng-valid').when_present.select 'United States'
      customer_details.each do |k,v|
        browser.text_field(:name => k).when_present.set v
      end
      browser.checkbox(:name, /ccepted/).when_present.set
      screenshot(browser, "1")
      browser.button(:text=> /Continue/).when_present.click

      browser.h2(:text => /Payment Information/).wait_until_present
      screenshot(browser, "2")
      raise StandardError if browser.text.include? 'error'
      browser.input(:id => "accountId", :value => "").wait_while_present(30)
      browser.input(:id => "accountId").value
    rescue StandardError
      screenshot(browser, 'error')
      raise StandardError, 'Aws returned error on the page when submitting customer information.'
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      'https://portal.aws.amazon.com/billing/signup#/account'
    end
  end
end
