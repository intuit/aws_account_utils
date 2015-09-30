require 'spec_helper'

describe AwsAccountUtils::CustomizeUrl do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::CustomizeUrl.new logger, browser, options }
  let(:browser) { double 'browser' }
  let(:button) { double 'button' }
  let(:text_field) { double 'text_field' }


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
  it "should" do

  end
end