require 'spec_helper'

describe AwsAccountUtils::AccountRegistration do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::AccountRegistration.new logger, browser, options }
  let(:browser) { double 'browser' }
  let(:button) { double 'button' }
  let(:text_field) { double 'text_field' }
  let(:error_header) { "There was a problem with your request" }
  let(:error_body)   { "an account already exists with the e-mail" }

  let(:url) { url }
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

  url =  "https://www.amazon.com/ap/register?"
  url << "&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select"
  url << "&create=1&openid.assoc_handle=aws&accountStatusPolicy=P1"
  url << "&openid.ns=http://specs.openid.net/auth/2.0"
  url << "&openid.identity=http://specs.openid.net/auth/2.0/identifier_select"
  url << "&openid.mode=checkid_setup"
  url << "&openid.return_to=https://console.aws.amazon.com/billing/signup"

  it "should setup Enterprise Support" do
    expect(logger).to receive(:debug).with('Signing up for a new account.')
    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:text_field).with({:id=>"ap_customer_name"}).and_return(text_field)
    expect(text_field).to receive(:wait_until_present)
    expect(browser).to receive(:text_field).with({:id=>"ap_customer_name"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_email"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_email_check"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_password"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_password_check"}).and_return(text_field)
    expect(text_field).to receive(:when_present).exactly(5).times.and_return(text_field)
    expect(text_field).to receive(:set).exactly(5).times
    expect(browser).to receive(:button).with({:id=>"continue-input"}).and_return(button)
    expect(subject).to receive(:screenshot).with(browser, "1")
    expect(subject).to receive(:screenshot).with(browser, "2")
    expect(button).to receive(:when_present).and_return(button)
    expect(button).to receive(:click)
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/).and_return(browser)
    expect(browser).to receive(:exist?).and_return(false)
    expect(subject.signup).to be_truthy
  end

  it "should raise an error if the page has an error" do
    expect(logger).to receive(:debug).with('Signing up for a new account.')
    expect(browser).to receive(:goto).with(url)
    expect(browser).to receive(:text_field).with({:id=>"ap_customer_name"}).and_return(text_field)
    expect(text_field).to receive(:wait_until_present)
    expect(browser).to receive(:text_field).with({:id=>"ap_customer_name"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_email"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_email_check"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_password"}).and_return(text_field)
    expect(browser).to receive(:text_field).with({:id=>"ap_password_check"}).and_return(text_field)
    expect(text_field).to receive(:when_present).exactly(5).times.and_return(text_field)
    expect(text_field).to receive(:set).exactly(5).times
    expect(browser).to receive(:button).with({:id=>"continue-input"}).and_return(button)
    expect(subject).to receive(:screenshot).with(browser, "1")
    expect(subject).to receive(:screenshot).with(browser, "2")
    expect(button).to receive(:when_present).and_return(button)
    expect(button).to receive(:click)
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/).and_return(browser)
    expect(browser).to receive(:exist?).and_return(true)
    expect(subject).to receive(:screenshot).with(browser, "error")
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/).and_return(browser)
    expect(browser).to receive(:h6).and_return(browser)
    expect(browser).to receive(:text).and_return(error_header)
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/).and_return(browser)
    expect(browser).to receive(:p).and_return(browser)
    expect(browser).to receive(:text).and_return(error_body)
    expect{subject.signup}.to raise_error(StandardError,"AWS signup error: \"#{error_header}: #{error_body}\"")

  end
end
