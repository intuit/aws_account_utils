require 'aws_account_utils/base'

module AwsAccountUtils
  class RootAccessKeys < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def create(account_email, account_password)
      logger.debug "Creating root access/secret key"
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      clear_warning if browser.div(:id => 'modal-content', :text => warning_text)
      browser.i(:xpath => "id('credaccordion')/div[3]/div[1]/div/div[1]/i").when_present.click
      browser.button(:text => /Create New Access Key/).when_present.click
      browser.a(:text => /Show Access Key/).when_present.click
      screenshot(browser, "1")
      parse_keys browser.text
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def delete(account_email, account_password)
      logger.debug "Deleting root access/secret key"
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password
      clear_warning if browser.div(:id => 'modal-content', :text => warning_text)
      browser.i(:xpath => "id('credaccordion')/div[3]/div[1]/div/div[1]/i").when_present.click
      keys_to_delete? ? delete_all_keys : true
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def delete_all_keys
      tries ||= 4
      browser.link(:text => 'Delete').when_present.click
      logger.debug "Deleting access_key: #{browser.div(:id => 'modal-content').strong.text}"
      browser.div(:text => /Are you sure you want to delete the access key/).wait_until_present
      browser.link(:text => /Yes/).when_present.click
      screenshot(browser, "2")
      browser.link(:text => /Yes/).wait_while_present
      screenshot(browser, "3")
      raise StandardError if keys_to_delete?
    rescue StandardError
      retry unless (tries -= 1).zero?
      false
    else
      true
    end

    def url
      'https://console.aws.amazon.com/iam/home?#security_credential'
    end

    def warning_text
      'You are accessing the security credentials page for your AWS account. The account credentials provide unlimited access to your AWS resources.'
    end

    def keys_to_delete?
     a = browser.a(:class => 'Delete').exist?
      a
    end

    def clear_warning
      browser.label(:text => /Don't show me this message again/).wait_until_present
      screenshot(browser, "4")
      browser.element(:id => 'continue').when_present.click
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    def parse_keys(text)
      { access_key: text.split("\n")[-4],
        secret_key: text.split("\n")[-2] }
    end
  end
end
