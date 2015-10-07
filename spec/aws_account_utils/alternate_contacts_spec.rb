require 'spec_helper'

describe AwsAccountUtils::AlternateContacts do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::AlternateContacts.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:a) { double 'browser element a' }
  let(:div) { double 'browser element div' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://console.aws.amazon.com/billing/home?#/account' }
  let(:contacts) { { 'operations'  => { 'name' => 'Operations Name',
                                        'title' => 'Operations Title',
                                        'email' => 'operations@test.com',
                                        'phoneNumber' => '888-888-1212'},
                     'security' => { 'name' => 'Security Name',
                                     'title' => 'Security Title',
                                     'email' => 'Security@test.com',
                                     'phoneNumber' => '888-888-1212'}} }


  it "should setup Alternate Contacts" do
    expect(logger).to receive(:debug).with('Setting alternate account contacts.')
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
                   .with({:xpath=>"//a[@ng-click=\"toggleEditingAlternateContactsInfoState()\"]"})
                   .and_return a
    expect(a).to receive(:when_present).and_return a
    expect(a).to receive(:click)


    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.operationsContact.name\"]"})
                   .and_return input
    expect(input).to receive(:set).with('Operations Name').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.operationsContact.title\"]"})
                   .and_return input
    expect(input).to receive(:set).with('Operations Title').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.operationsContact.email\"]"})
                   .and_return input
    expect(input).to receive(:set).with('operations@test.com').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.operationsContact.phoneNumber\"]"})
                   .and_return input
    expect(input).to receive(:set).with('888-888-1212').and_return input

    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.securityContact.name\"]"})
                   .and_return input
    expect(input).to receive(:set).with('Security Name').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.securityContact.title\"]"})
                   .and_return input
    expect(input).to receive(:set).with('Security Title').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.securityContact.email\"]"})
                   .and_return input
    expect(input).to receive(:set).with('Security@test.com').and_return input
    expect(browser).to receive(:input)
                   .with({:xpath=>"//input[@ng-model=\"alternateContacts.securityContact.phoneNumber\"]"})
                   .and_return input
    expect(input).to receive(:set).with('888-888-1212').and_return input

    expect(input).to receive(:when_present).exactly(8).times.and_return input
    expect(input).to receive(:to_subtype).exactly(8).times.and_return input

    expect(browser).to receive(:button)
                   .with({:xpath=>"//button[@ng-click=\"updateAlternateContacts()\"]"})
                   .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:div)
                   .with({:xpath=>"//div[@ng-show=\"options.status == 'success'\"]"})
                   .and_return div
    expect(div).to receive(:wait_until_present)

    expect(subject.set('my_user', 'my_password', contacts)).to be_truthy
  end
end
