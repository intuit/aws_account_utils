require 'spec_helper'

describe AwsAccountUtils::EmailPreferences do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::EmailPreferences.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:strong) { double 'browser strong' }
  let(:h3) { double 'browser element h3' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://aws.amazon.com/email-preferences/' }

  it "should set email preferences" do
    expect(logger).to receive(:debug).with('Setting email preferences.')
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

    expect(browser).to receive(:input)
                   .with({:id => 'email_preferences_optout_all_true'})
                   .and_return input
    expect(input).to receive(:when_present).and_return input
    expect(input).to receive(:click)

    expect(browser).to receive(:input).with({:value => 'Save Changes'})
                   .and_return input
    expect(input).to receive(:when_present).and_return input
    expect(input).to receive(:click)

    expect(browser).to receive(:h3)
                   .with({:text => /You have successfully updated your email preferences/})
                   .and_return h3
    expect(h3).to receive(:wait_until_present)

    expect(subject.opt_out('my_user', 'my_password')).to be_nil
  end
end