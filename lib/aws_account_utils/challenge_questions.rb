require 'aws_account_utils/base'
require 'aws_account_utils/login'
require 'random-word'

module AwsAccountUtils
  class ChallengeQuestions < Base
    attr_reader :logger, :browser

    def initialize(logger, browser)
      @logger = logger
      @browser = browser
    end

    def create(account_email, account_password, challenge_words)
      logger.debug "Setting security challenge answers."
      Login.new(logger, browser).execute url,
                                         account_email,
                                         account_password

      browser.a(:xpath => '//a[@ng-click="toggleEditingSecurityQuestionsInfoState()"]').when_present.click

      challenge_words = rand_challenge_words if challenge_words.empty?
      challenge_words.each do |num, word|
        browser.input(:xpath => "//input[@ng-model=\"selectedSecurityQuestions.question#{num}.answer\"]").to_subtype.when_present.set word
      end

      screenshot(browser, "1")
      browser.button(:xpath => '//button[@ng-click="updateSecurityQuestions()"]').when_present.click
      browser.a(:xpath => '//a[@ng-click="toggleEditingSecurityQuestionsInfoState()"]').wait_until_present
      challenge_words
    rescue Watir::Wait::TimeoutError, Net::ReadTimeout => e
      screenshot(browser, "error")
      raise StandardError, "#{self.class.name} - #{e}"
    end

    private
    def rand_challenge_words
      RandomWord.exclude_list << (/_/) if RandomWord.exclude_list.none?

      @challenge_words ||= (1..3).inject({}) do |hash, num|
        hash[num] = RandomWord.nouns.next
        hash
      end
    end

    def url
      'https://portal.aws.amazon.com/gp/aws/manageYourAccount'
    end

  end
end
