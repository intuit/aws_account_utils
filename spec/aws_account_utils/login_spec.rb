require 'spec_helper'

describe AwsAccountUtils::AccountRegistration do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::Login.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:strong) { double 'browser strong' }
  let(:a) { double 'browser element a' }
  let(:input) { double 'browser input' }
  let(:label) { double 'browser label' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://portal.aws.amazon.com/gp/aws/manageYourAccount' }

  it "should log into aws if presented with login page" do
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

    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url)
                   .and_return('https://www.amazon.com/ap/signin?')
    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(subject.execute(url, 'my_user', 'my_password')).to be_nil
  end

  it "should not attempt to log into aws if login page is not displayed" do
    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url).and_return(url)

    expect(subject.execute(url, 'my_user', 'my_password')).to be true
  end
end