require 'spec_helper'

describe AwsAccountUtils::EnterpriseSupport do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::EnterpriseSupport.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:span) { double 'browser span' }
  let(:p) { double 'browser element p' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://portal.aws.amazon.com/gp/aws/developer/registration/index.html' }
  let(:status_url) { 'https://console.aws.amazon.com/support/home' }
  confirmation_text  = "Thank you for creating an Amazon Web Services (AWS) "
  confirmation_text << "Account. We are in the process of activating your "
  confirmation_text << "account. For most customers, activation only takes a "
  confirmation_text << "couple minutes, but it can sometimes take a few hours "
  confirmation_text << "if additional account verification is required. We will "
  confirmation_text << "notify you by email when your account is activated."

  before (:each) do
    expect(browser).to receive(:text_field).with({:id => "ap_email"})
                           .and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password"})
                           .and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:id => "signInSubmit-input"})
                           .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)
  end

  it "should enable enterprise support" do
    expect(logger).to receive(:debug).with('Enabling enterprise support.')

    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url)
                           .and_return('https://www.amazon.com/ap/signin?')

    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:input).with({:value => 'AWSSupportEnterprise'})
                                      .and_return input
    expect(input).to receive(:when_present).and_return input
    expect(input).to receive(:click)

    expect(browser).to receive(:span).with({:text => /Continue/})
                           .and_return span
    expect(span).to receive(:when_present).with(60).and_return span
    expect(span).to receive(:click)

    expect(browser).to receive(:p)
                           .with({:text => confirmation_text})
                           .and_return p
    expect(p).to receive(:wait_until_present)

    expect(subject.enable('my_user', 'my_password')).to be true
  end

  it 'should return true if enterprise support is enabled' do
    expect(logger).to receive(:debug).with('Checking to see if enterprise support is enabled.')

    expect(browser).to receive(:goto).with(status_url)
    expect(browser).to receive(:url)
                           .and_return('https://www.amazon.com/ap/signin?')

    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:text).and_return browser
    expect(browser).to receive(:include?).with("Enterprise Support Plan").and_return true

    expect(subject.existing_support?('my_user', 'my_password')).to be true
  end

  it 'should return false if enterprise support is not enabled' do
    expect(logger).to receive(:debug).with('Checking to see if enterprise support is enabled.')

    expect(browser).to receive(:goto).with(status_url)
    expect(browser).to receive(:url)
                           .and_return('https://www.amazon.com/ap/signin?')

    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:text).and_return browser
    expect(browser).to receive(:include?).with("Enterprise Support Plan").and_return false

    expect(subject.existing_support?('my_user', 'my_password')).to be false
  end
end