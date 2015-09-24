require 'aws_account_utils/base'
require 'random-word'

module AwsAccountUtils
  class ChallengeQuestions < Base
    attr_reader :logger, :browser, :options

    def initialize(logger, browser, options)
      @logger = logger
      @browser = browser
      @options = options
    end

    def create(challenge_words = {})
      logger.debug "Entering customer details."
      Login.new(logger, browser).execute url,
                                         options[:account_email],
                                         options[:account_password]

      browser.a(:xpath => '//a[@ng-click="toggleEditingSecurityQuestionsInfoState()"]').when_present.click

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
    def challenge_words
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
