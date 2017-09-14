require 'spec_helper'

describe AwsAccountUtils::Account do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::Account.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:text_field) { double 'browser text field' }
  let(:checkbox) { double 'browser checkbox' }
  let(:text) { double 'browser text' }
  let(:p) { double 'browser p element' }
  let(:button) { double 'browser button' }
  let(:div) { double 'browser div' }
  let(:url) { 'https://console.aws.amazon.com/billing/home?#/account' }

  it "should create a url alias" do
    expect(logger).to receive(:debug).with('Closing AWS account.')

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

    expect(browser).to receive(:checkbox).with({:ng_model => "isClosingAccount"}).and_return checkbox
    expect(checkbox).to receive(:when_present).and_return checkbox
    expect(checkbox).to receive(:set)

    expect(browser).to receive(:button).with({:text => /Close Account/}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:wait_until).and_return browser

    expect(browser).to receive(:div).with({:class=>"modal fade  in"}).and_return div
    expect(div).to receive(:button).with({:ng_click=>"closeAccount()"}).and_return div
    expect(div).to receive(:when_present).and_return div
    expect(div).to receive(:click)

    expect(browser).to receive(:p).with({:text => /Are you sure you want to close your account?/}).and_return p
    expect(p).to receive(:wait_while_present).and_return p

    expect(browser).to receive(:wait_until).and_return browser

    expect(subject.close('my_user', 'my_password')).to be_truthy
  end
end