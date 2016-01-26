require 'aws_account_utils/account'
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
require 'aws_account_utils/company_name'
require 'aws_account_utils/logout'

module AwsAccountUtils
  class AwsAccountUtils
    attr_reader :log_level, :logger, :browser, :screenshots

    def initialize(log_level: :info, logger: nil, browser: nil, screenshots: nil)
      @log_level = log_level
      @logger = logger
      @browser = browser
      @screenshots = screenshots

      Settings.set_screenshot_dir screenshots if screenshots
    end

    def create_account(account_name:, account_email:, account_password:, account_details:)
      raise ArgumentError, "account_detials: must be a hash." unless account_details.is_a?(Hash)
      account_registration.signup account_name, account_email, account_password
      resp = customer_information.submit account_email, account_password, account_details
      logger.info 'Successfully created account.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def check_enterprise_support(account_email:, account_password:)
      resp = enterprise_support.existing_support? account_email, account_password
      logger.info 'Enterprise support was already enabled' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def change_root_password(account_email:, account_password:, new_password:)
      resp = password.change(account_email, account_password, new_password)
      logger.info 'Changed root password.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def close_account(account_email:, account_password:)
      resp = account.close(account_email, account_password)
      logger.info 'Closed Account.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def confirm_consolidated_billing(account_email:, account_password:, confirmation_link:)
      resp = consolidated_billing.confirm account_email, account_password, confirmation_link
      logger.info 'Consolidated billing has been confirmed' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def create_root_access_keys(account_email:, account_password:)
      resp = root_access_keys.create account_email, account_password
      logger.info 'Created root access keys.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def delete_root_access_keys(account_email:, account_password:)
      resp = root_access_keys.delete account_email, account_password
      logger.info 'Deleted all root access keys.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def email_opt_out(account_email:, account_password:)
      resp = email_preferences.opt_out account_email, account_password
      logger.info 'Successfully opted out of all emails' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def enable_enterprise_support(account_email:, account_password:)
      resp = enterprise_support.enable account_email, account_password
      logger.info 'Enabled enterprise support' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def enable_iam_billing(account_email:, account_password:)
      resp = iam_billing.enable account_email, account_password
      logger.info 'Successfully enabled IAM billing' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def existing_consolidated_billing?(account_email:, account_password:)
      resp = consolidated_billing.existing? account_email, account_password
      logger.info 'Consolidated billing has already been setup' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def logout_from_console
      resp = logout.execute
      logger.info 'Logged out of console' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def request_consolidated_billing(master_account_email:, master_account_password:, account_email:)
      resp = consolidated_billing.request master_account_email, master_account_password, account_email
      logger.info 'Consolidated billing has been requested' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def set_challenge_questions(account_email:, account_password:, answers:)
      raise ArgumentError, "answers: must be a hash." unless answers.is_a?(Hash)

      resp = challenge_questions.create account_email, account_password, answers
      logger.info 'Security Challenge Questions have been setup' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def set_alternate_contacts(account_email:, account_password:, contact_info:)
      raise ArgumentError, "contact_info: must be a hash." unless contact_info.is_a?(Hash)

      resp = alternate_contacts.set account_email, account_password, contact_info
      logger.info 'Set alternate contacts.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    def set_company_name(account_email:, account_password:)
      resp = company_name.set account_email, account_password
      logger.info 'Set company name.' if resp
      resp
    ensure
      browser.close rescue nil
    end

    private
    def account_registration
      @account_registration ||= AccountRegistration.new logger, browser
    end

    def alternate_contacts
      @alternate_contacts ||= AlternateContacts.new logger, browser
    end

    def company_name
      @company_name ||= CompanyName.new logger, browser
    end

    def browser
      @browser ||= WatirBrowser.new(logger).create
    end

    def challenge_questions
      @challenge_questions ||= ChallengeQuestions.new logger, browser
    end

    def account
      @account ||= Account.new logger, browser
    end

    def consolidated_billing
      @consolidated_billing ||= ConsolidatedBilling.new logger, browser
    end

    def customer_information
      @customer_information ||= CustomerInformation.new logger, browser
    end

    def email_preferences
      @email_preferences ||= EmailPreferences.new logger, browser
    end

    def enterprise_support
      @enterprise_support ||= EnterpriseSupport.new logger, browser
    end

    def iam_billing
      @iam_billing ||= IamBilling.new logger, browser
    end

    def logger
      @logger ||= AccountLogger.new(log_level)
    end

    def password
      @password ||= Password.new logger, browser
    end

    def root_access_keys
      @root_access_keys ||= RootAccessKeys.new logger, browser
    end

    def logout
      @logout ||= Logout.new logger, browser
    end
  end
end
