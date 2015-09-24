require 'aws_account_utils/base'

module AwsAccountUtils
  class Password < Base
    attr_reader :logger, :browser, :options

    def initialize(logger, browser, options)
      @logger = logger
      @browser = browser
      @options = options
    end

    def change(new_password)
      logger.debug 'Changing root password.'
      Login.new(logger, browser).execute url,
                                         options[:account_email],
                                         options[:account_password]
      browser.h1(:text => /Change Name, E-mail Address, or Password/).wait_until_present
      screenshot(browser, "1")
      browser.button(:id => 'cnep_1A_change_password_button-input').when_present.click
      screenshot(browser, "2")
      browser.text_field(:id =>"ap_password").when_present.set options[:account_password]
      browser.text_field(:id =>"ap_password_new").when_present.set new_password
      browser.text_field(:id =>"ap_password_new_check").when_present.set new_password
      screenshot(browser, "3")
      browser.button(:id => "cnep_1D_submit_button-input").when_present.click
      raise StandardError if browser.div(:id => /message_(error|warning)/).exist?
      browser.h6(:text => /Success/).exist?
    rescue StandardError => e
      screenshot(browser, "error")
      logger.debug "Standard error in #{self.class.name} - #{e}"
      error_header = browser.div(:id => /message_(error|warning)/).h6.text
      error_body = browser.div(:id => /message_(error|warning)/).p.text
      logger.debug "AWS Password Change Error: \"#{error_header}: #{error_body}\""
      false
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def url
      url = "https://www.amazon.com/ap/cnep?_encoding=UTF8"
      url<< "&openid.assoc_handle=aws"
      url<< "&openid.return_to=https%3A%2F%2Fconsole.aws.amazon.com%2Fbilling%2Fhome%23%2Faccount"
      url<< "&openid.mode=id_res&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
      url<< "&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select"
      url<< "&openid.pape.max_auth_age=600"
      url<< "&openid.pape.preferred_auth_policies=http%3A%2F%2Fschemas.openid.net%2Fpape%2Fpolicies%2F2007%2F06%2Fmulti-factor-physical"
      url<< "&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0"
      url<< "&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select"
    end
  end
end
