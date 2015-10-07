require 'spec_helper'

describe AwsAccountUtils::IamBilling do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::IamBilling.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:strong) { double 'browser strong' }
  let(:a) { double 'browser element a' }
  let(:input) { double 'browser input' }
  let(:label) { double 'browser label' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://portal.aws.amazon.com/gp/aws/manageYourAccount' }

  it "should create a url alias" do
    expect(logger).to receive(:debug).with('Enabling IAM User Access to Billing Information')
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

    expect(browser).to receive(:a).with({:xpath => '//a[@ng-click="toggleEditingIAMPreferencesInfoState()"]'}).and_return a
    expect(a).to receive(:when_present).and_return a
    expect(a).to receive(:click)

    expect(browser).to receive(:label).with({:xpath => '//label[@ng-show="isEditingIAMPreferencesInfo"]'}).and_return label
    expect(label).to receive(:when_present).and_return label
    expect(label).to receive(:click)

    expect(browser).to receive(:button).with({:xpath => '//button[@ng-click="updateIAMPreferences()"]'}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:strong).with({:text => /IAM user access to billing information is activated./}).and_return strong
    expect(strong).to receive(:wait_until_present)

    expect(subject.enable('my_user', 'my_password')).to be_nil
  end
end
