require 'aws_account_utils/base'

module AwsAccountUtils
  class EnterpriseSupport < Base
    attr_reader :logger, :browser, :options

    def initialize(logger, browser, options)
      @logger = logger
      @browser = browser
      @options = options
    end

    def enable
      logger.debug 'Enabling enterprise support.'
      Login.new(logger, browser).execute support_registration_url,
                                         options[:account_email],
                                         options[:account_password]
      browser.input(:value => "AWSSupportEnterprise").when_present(timeout = 60).click
      browser.span(:text => /Continue/).when_present(timeout = 60).click
      screenshot(browser, "1")
      browser.p(:text => confirmation_text).wait_until_present(timeout = 60)
      screenshot(browser, "2")
      true
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      page_error?
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def existing_support?
      logger.debug 'Checking to see if enterprise support is enabled.'
      Login.new(logger, browser).execute support_status_url,
                                         options[:account_email],
                                         options[:account_password]

      screenshot(browser, "1")
      browser.text.include? 'Enterprise Support Plan'
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      page_error?
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def page_error?
      if browser.text.include? 'error'
        logger.warn 'AWS webpage contains an error.'
        screenshot(browser, "aws_page_error")
        true
      end
    end

    def confirmation_text
      "Thank you for creating an Amazon Web Services (AWS) Account. We are in the process of activating your account. For most customers, activation only takes a couple minutes, but it can sometimes take a few hours if additional account verification is required. We will notify you by email when your account is activated."
    end

    def support_registration_url
      'https://portal.aws.amazon.com/gp/aws/developer/registration/index.html'
    end

    def support_status_url
      'https://console.aws.amazon.com/support/home'
    end
  end
end
