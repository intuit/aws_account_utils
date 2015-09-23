module AwsAccountUtils
  class CustomerInformation < Base
    attr_reader :logger, :browser, :options

    def initialize(logger, browser, options)
      @logger = logger
      @browser = browser
      @options = options
    end

    def submit(customer_details)
      logger.debug "Entering customer details."
      Login.new(logger, browser).execute url,
                                         options[:account_email],
                                         options[:account_password]
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
      raise StandardError, 'Steps: AwsCustomerInformation Aws returned error on page.'
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end
  end
end
