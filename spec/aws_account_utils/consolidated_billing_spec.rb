require 'spec_helper'

describe AwsAccountUtils::ConsolidatedBilling do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::ConsolidatedBilling.new logger, browser }
  let(:browser) { double 'browser' }
  let(:h2) { double 'browser element h2' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://console.aws.amazon.com/billing/home?#/consolidatedbilling/sendrequest' }

  it "should set the answers to the security questions" do
    expect(logger).to receive(:debug)
                  .with('Submitting consolidated billing request from master account master_acct_user to acct_email@test.com')
    expect(browser).to receive(:text_field).with({:id=>"ap_email"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id=>"ap_password"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:id=>"signInSubmit-input"}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url).and_return('https://www.amazon.com/ap/signin?')
    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:text_field).with({:name=>"emailaddresses"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:class=>"btn btn-primary margin-left-10"}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:h2).with({:text=>/Manage Requests and Accounts/}).and_return h2
    expect(h2).to receive(:wait_until_present)

    expect(subject.request('master_acct_user',
                           'master_acct_password',
                           'acct_email@test.com')).to be_nil
  end
end