require 'aws_account_utils/base'
require 'aws_account_utils/version'
require 'aws_account_utils/account_logger'
require 'aws_account_utils/watir_browser'
require 'aws_account_utils/account_registration'
require 'aws_account_utils/customer_information'
require 'aws_account_utils/settings'
require 'aws_account_utils/iam_billing'
require 'aws_account_utils/email_preferences'
require 'aws_account_utils/enterprise_support'
require 'aws_account_utils/consolidated_billing'
require 'aws_account_utils/root_access_keys'
require 'aws_account_utils/password'
require 'aws_account_utils/alternate_contacts'
require 'aws_account_utils/logout'

module AwsAccountUtils
  class AwsAccountUtils
    attr_reader :options, :logger, :browser, :screenshots

    # def initialize(options = {})
    #   @options = options
    #   options[:log_level] ||= 'info'
    #
    #   [:logger, :browser].each do |opt|
    #     if value = options[opt]
    #       instance_variable_set("@#{opt.to_s}", value)
    #     end
    #   end
    #   Settings.set_screenshot_dir options[:screenshots] if options[:screenshots]
    # end

    def initialize(logger: nil, browser: nil, screenshots: nil)
      @browser = browser
      @logger = logger
      @screenshots = screenshots

      Settings.set_screenshot_dir screenshots if screenshots
    end

    def create_account(account_name:, account_email:, account_password:, account_details:)
      raise ArgumentError, "account_detials: must be a hash." unless account_details.is_a?(Hash)
      account_registration.signup account_name, account_email, account_password
      resp = customer_information.submit account_details
      logger.info 'Successfully created account.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def check_enterprise_support
      resp = enterprise_support.existing_support?
      logger.info 'Enterprise support was already enabled' if resp
      resp
    ensure
      browser.close
    end

    def change_root_password(new_password)
      resp = password.change(new_password)
      logger.info 'Changed root password.' if resp
      resp
    ensure
      browser.close
    end

    def confirm_consolidated_billing(confirmation_link)
      resp = consolidated_billing.confirm confirmation_link
      logger.info 'Consolidated billing has been confirmed' if resp
      resp
    ensure
      browser.close
    end

    def create_root_access_keys
      resp = root_access_keys.create
      logger.info 'Created root access keys.' if resp
      resp
    ensure
      browser.close
    end

    def delete_root_access_keys
      resp = root_access_keys.delete
      logger.info 'Deleted all root access keys.' if resp
      resp
    ensure
      browser.close
    end

    def email_opt_out
      resp = email_preferences.opt_out
      logger.info 'Successfully opted out of all emails' if resp
      resp
    ensure
      browser.close
    end

    def enable_enterprise_support
      resp = enterprise_support.enable
      logger.info 'Enabled enterprise support' if resp
      resp
    ensure
      browser.close
    end

    def enable_iam_billing
      resp = iam_billing.enable
      logger.info 'Successfully enabled IAM billing' if resp
      resp
    ensure
      browser.close
    end

    def existing_consolidated_billing?
      resp = consolidated_billing.existing?
      logger.info 'Consolidated billing has already been setup' if resp
      resp
    ensure
      browser.close
    end

    def logout_from_console
      resp = logout.execute
      logger.info 'Logged out of console' if resp
      resp
    ensure
      browser.close
    end

    def request_consolidated_billing(master_account_email, master_account_password)
      resp = consolidated_billing.request master_account_email, master_account_password
      logger.info 'Consolidated billing has been requested' if resp
      resp
    ensure
      browser.close
    end

    def set_challenge_questions(answers = {})
      resp = challenge_questions.create answers
      logger.info 'Security Challenge Questions have been setup' if resp
      resp
    ensure
      browser.close
    end

    def set_alternate_contacts(contact_info = {})
      resp = alternate_contacts.set(contact_info)
      logger.info 'Set alterante contacts.' if resp
      resp
    ensure
      browser.close
    end

    private
    def account_registration
      @account_registration ||= AccountRegistration.new logger, browser
    end

    def alternate_contacts
      @alternate_contacts ||= AlternateContacts.new logger, browser, options
    end

    def browser
      @browser ||= WatirBrowser.new(logger).create
    end

    def challenge_questions
      @challenge_questions ||= ChallengeQuestions.new logger, browser, options
    end

    def consolidated_billing
      @consolidated_billing ||= ConsolidatedBilling.new logger, browser, options
    end

    def customer_information
      @customer_information ||= CustomerInformation.new logger, browser, options
    end

    def email_preferences
      @email_preferences ||= EmailPreferences.new logger, browser, options
    end

    def enterprise_support
      @enterprise_support ||= EnterpriseSupport.new logger, browser, options
    end

    def iam_billing
      @iam_billing ||= IamBilling.new logger, browser, options
    end

    def logger
      @logger ||= AccountLogger.new(options[:log_level])
    end

    def password
      @password ||= Password.new logger, browser, options
    end

    def root_access_keys
      @root_access_keys ||= RootAccessKeys.new logger, browser, options
    end

    def logout
      @logout ||= Logout.new logger, browser
    end
  end
end

details = { 'fullName'     => 'Hermen Munster',
            'company'      => 'The Munsters',
            'addressLine1' => '1313 Mockingbird Lane',
            'city'         => 'Mockingbird Heights',
            'state'        => 'CA',
            'postalCode'   => '92000',
            'phoneNumber'  => '(800) 555-1212',
            'guess'        => 'Test Account' }

a = AwsAccountUtils::AwsAccountUtils.new
c = a.create_account(account_name: 'My Test Account 01',
                     account_email: 'adfefef@gmail.com',
                     account_password: 'foobar1212121',
                     account_details: details)
c