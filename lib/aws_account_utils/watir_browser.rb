require 'aws_account_utils/base'
require 'watir-webdriver'

module AwsAccountUtils
  class WatirBrowser
    attr_reader :logger

    def initialize(logger)
      @logger  = logger
    end

    def create
      logger.debug "Launching new browser."
      Watir::Browser.new(:firefox, :profile => set_firefox_profile)
    end

    private
    def set_firefox_profile
      profile = Selenium::WebDriver::Firefox::Profile.new

      if proxy
        proxy_settings.each do |k,v|
          profile["network.proxy.#{k}"] = v
        end
      end

      profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
      profile['browser.privatebrowsing.autostart'] = true
      profile.native_events = false
      profile
    end

    def proxy_settings
      {
          'http'          => proxy,
          'http_port'     => 80,
          'ssl'           => proxy,
          'ssl_port'      => 80,
          'no_proxies_on' => '127.0.0.1',
          'type'          => 1
      }
    end

    def proxy
      @proxy ||= ENV['HTTP_PROXY']
    end

  end
end