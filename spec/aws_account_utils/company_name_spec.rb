require 'spec_helper'

describe AwsAccountUtils::CompanyName do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::CompanyName.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:a) { double 'browser element a' }
  let(:div) { double 'browser element div' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://console.aws.amazon.com/billing/home?#/account' }
  let(:name) { 'company_name' }

  it "should update Contact Details" do
    expect(logger).to receive(:debug).with('Updating Company Name details.')
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

    expect(browser).to receive(:a)
                   .with({:xpath=>"//a[@ng-click=\"toggleEditingContactInfoState()\"]"})
                   .and_return a
    expect(a).to receive(:when_present).and_return a
    expect(a).to receive(:click)


    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"address.company\"]"})
                   .and_return input
    expect(input).to receive(:to_subtype).and_return input
    expect(input).to receive(:set).with('company_name').and_return input


    expect(browser).to receive(:button)
                   .with({:xpath=>"//button[@ng-click=\"updateContactInformation()\"]"})
                   .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:div)
                   .with({:xpath=>"//div[@ng-show=\"options.status == 'success'\"]"})
                   .and_return div
    expect(div).to receive(:wait_until_present)

    expect(subject.set('my_user', 'my_password', 'company_name')).to be_truthy
  end
end
