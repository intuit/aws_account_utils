require 'spec_helper'

describe AwsAccountUtils::Logout do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::Logout.new logger, browser }
  let(:browser) { double 'browser' }
  let(:url) { 'https://console.aws.amazon.com/support/logout!doLogout' }

  it "should log out of aws console" do
    expect(logger).to receive(:debug).with('Logging out of AWS.')
    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:wait_until).and_return browser
    expect(browser).to receive(:text).and_return browser
    expect(browser).to receive(:include?).with("Sign In to the Console").and_return true

    expect(subject.execute).to be true
  end
end