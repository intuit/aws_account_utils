module AwsAccountUtils
  class AlternateContacts < Base
    attr_reader :logger, :browser, :options

    def initialize(logger, browser, options)
      @logger = logger
      @browser = browser
      @options = options
    end

    def set(contact_info = {})
      logger.debug "Setting alternate account contacts."
      Login.new(logger, browser).execute url,
                                         options[:account_email],
                                         options[:account_password]
      browser.a(:xpath => '//a[@ng-click="toggleEditingAlternateContactsInfoState()"]').when_present.click
      form_inputs(contact_info)
      screenshot(browser, "1")
      browser.button(:xpath => '//button[@ng-click="updateAlternateContacts()"]').when_present.click
      browser.div(:xpath => '//div[@ng-show="options.status == \'success\'"]').wait_until_present
      true
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def form_inputs(requestor_info)
      requestor_info.each do |type, details|
        details.each do |key, value|
          browser.input(:xpath => "//input[@ng-model=\"alternateContacts.#{type}Contact.#{key}\"]").to_subtype.when_present.set value
        end
      end
    end

    def url
      'https://console.aws.amazon.com/billing/home?#/account'
    end

  end
end
