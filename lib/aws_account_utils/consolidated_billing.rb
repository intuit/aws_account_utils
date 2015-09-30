require 'aws_account_utils/base'

module AwsAccountUtils
  class ConsolidatedBilling < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def request(master_account_email, master_account_password, account_email)
      logger.debug "Submitting consolidated billing request from master account #{master_account_email} to #{account_email}"
      Login.new(logger, browser).execute billing_request_url,
                                         master_account_email,
                                         master_account_password

      browser.text_field(:name => "emailaddresses").when_present.set account_email
      screenshot(browser, "1")
      browser.button(:class => "btn btn-primary margin-left-10").when_present.click
      browser.h2(:text => /Manage Requests and Accounts/).wait_until_present
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def confirm(account_email, account_password, confirmation_link)
      logger.debug "Confirming consolidated billing"

      Login.new(logger, browser).execute confirmation_link,
                                         account_email,
                                         account_password

      browser.button(:class => "btn btn-primary").when_present.click
      screenshot(browser, "1")
      browser.span(:text => /Accepting Request/).wait_while_present(timeout = 120)
      screenshot(browser, "2")
      true
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout, StandardError => e
      screenshot(browser, "error")
      page_error?
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def existing?(account_email, account_password)
      logger.debug "Checking to see if Consolidated Billing is already setup"

      Login.new(logger, browser).execute billing_established_url,
                                         account_email,
                                         account_password
      browser.h2(:text => /Consolidated Billing/).wait_until_present
      screenshot(browser, "1")
      billing_setup?
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def billing_setup?
      browser.text.include? 'Your account currently appears on the Consolidated Bill for the account below'
    end

    def page_error?
      if browser.text.include? 'error'
        logger.warn 'AWS webpage contains an error.'
        screenshot(browser, "aws_page_error")
        true
      end
    end

    def billing_request_url
      'https://console.aws.amazon.com/billing/home?#/consolidatedbilling/sendrequest'
    end

    def billing_established_url
      'https://console.aws.amazon.com/billing/home?#/consolidatedbilling'
    end
  end
end
