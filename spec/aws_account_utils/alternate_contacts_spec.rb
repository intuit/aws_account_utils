require 'spec_helper'

describe AwsAccountUtils::AlternateContacts do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::AlternateContacts.new logger, browser, options }
  let(:login) { AwsAccountUtils::Login.new logger, browser }

  let(:browser) { double 'browser' }
  let(:a) { double 'browser element a' }

  let(:button) { double 'button' }
  let(:text_field) { double 'text_field' }


  let(:url) { 'https://console.aws.amazon.com/billing/home?#/account' }
  let(:options) { {:log_level => 'debug',
                   :screenshots  => File.expand_path("/var/temp/screenshots", File.dirname(__FILE__)),
                   :account_name => 'Dune',
                   :account_email  => 'paul_atredies@gmail.com',
                   :account_password  => 'melange',
                   :customer_details => { 'fullName'     => 'The Planet Arrakis',
                                          'company'      => 'House Atreides',
                                          'addressLine1' => '1 Dune Way',
                                          'city'         => 'Imperium',
                                          'state'        => 'CA',
                                          'postalCode'   => '92000',
                                          'phoneNumber'  => '(800) 555-1212',
                                          'guess'        => 'Spice' }} }

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
    expect(login).to receive(:execute).with url, options[:account_email], options[:account_password]
    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:url).and_return('https://www.amazon.com/ap/signin?')
    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:a).with({:xpath => '//a[@ng-click="toggleEditingAlternateContactsInfoState()"]'}).and_return(a)
    expect(a).to receive(:when_present).and_return(a)
    expect(a).to receive(:click)
    expect(subject.set(contacts)).to be_truthy

  end
end
