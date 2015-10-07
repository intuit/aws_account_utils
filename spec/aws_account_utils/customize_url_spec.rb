require 'spec_helper'

describe AwsAccountUtils::CustomizeUrl do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::CustomizeUrl.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:strong) { double 'browser strong' }
  let(:h2) { double 'browser element h2' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://console.aws.amazon.com/iam/home?#home' }

  it "should create a url alias" do
    expect(logger).to receive(:debug).with('Creating URL alias: my.alternateurl.com')
    expect(browser).to receive(:text_field).with({:id => "ap_email"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:id => "signInSubmit-input"}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url).and_return('https://www.amazon.com/ap/signin?')
    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:h2).with({:text => /Welcome to Identity and Access Management/}).and_return h2
    expect(h2).to receive(:wait_until_present)

    expect(browser).to receive(:button).with({:text => /Customize/}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:input).with({:id => 'alias_input'}).and_return input
    expect(input).to receive(:when_present).and_return input
    expect(input).to receive(:to_subtype).and_return input
    expect(input).to receive(:set).with('my.alternateurl.com')

    expect(browser).to receive(:button).with({:text => /Yes, Create/}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:strong).with({:text => "https://my.alternateurl.com.signin.aws.amazon.com/console"}).and_return strong
    expect(strong).to receive(:wait_until_present)

    expect(subject.execute('my_user', 'my_password', 'my.alternateurl.com')).to be_truthy
  end
end
