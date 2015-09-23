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
    attr_reader :options

    def initialize(options)
      @options = options
      Settings.set_screenshot_dir options[:screenshots] if options[:screenshots]
    end

    def create_account
      account_registration.signup
      resp = customer_information.submit options[:customer_information]
      logger.info 'Successfully created account.' if resp
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

    def email_opt_out
      resp = email_preferences.opt_out
      logger.info 'Successfully opted out of all emails' if resp
      resp
    ensure
      browser.close
    end

    def check_enterprise_support
      resp = enterprise_support.existing_support?
      logger.info 'Enterprise support was already enabled' if resp
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

    def request_consolidated_billing(master_account_email, master_account_password)
      resp = consolidated_billing.request master_account_email, master_account_password
      logger.info 'Consolidated billing has been requested' if resp
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

    def existing_consolidated_billing?
      resp = consolidated_billing.existing?
      logger.info 'Consolidated billing has already been setup' if resp
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

    def change_root_password(new_password)
      resp = password.change(new_password)
      logger.info 'Changed root password.' if resp
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

    def logout_from_console
      resp = logout.execute
      logger.info 'Logged out of console' if resp
      resp
    ensure
      browser.close
    end

    private
    def account_registration
      @account_registration ||= AccountRegistration.new logger, browser, options
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