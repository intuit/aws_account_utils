require 'spec_helper'

describe AwsAccountUtils::CustomerInformation do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::CustomerInformation.new logger, browser }
  let(:browser) { double 'browser' }
  let(:h2) { double 'browser element h2' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:checkbox) { double 'browser checkbox' }
  let(:link) { double 'browser link' }
  let(:select_list) { double 'browser select list' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://portal.aws.amazon.com/billing/signup#/account' }
  let(:customer_details) { { 'fullName'     => 'Hermen Munster',
                             'company'      => 'The Munsters',
                             'addressLine1' => '1313 Mockingbird Lane',
                             'city'         => 'Mockingbird Heights',
                             'state'        => 'CA',
                             'postalCode'   => '92000',
                             'phoneNumber'  => '(800) 555-1212',
                             'guess'        => 'Test Account' } }

  before (:each) do
    expect(logger).to receive(:debug).with('Entering customer details.')

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

    expect(browser).to receive(:link).with({:text=>/AWS Customer Agreement/})
                                     .and_return link
    expect(link).to receive(:wait_until_present)

    expect(browser).to receive(:select_list)
                   .with({:class=>"control-select ng-pristine ng-valid"})
                   .and_return select_list
    expect(select_list).to receive(:when_present).and_return select_list
    expect(select_list).to receive(:select).with("United States")

    customer_details.each do |key, value|
      expect(browser).to receive(:text_field).with({:name=>"#{key}"})
                                             .and_return text_field
      expect(text_field).to receive(:when_present).and_return text_field
      expect(text_field).to receive(:set).with(value)
    end

    expect(browser).to receive(:checkbox).with(:name, /ccepted/)
                                         .and_return checkbox
    expect(checkbox).to receive(:when_present).and_return checkbox
    expect(checkbox).to receive(:set)

    expect(browser).to receive(:button).with({:text=>/Continue/})
                                       .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:h2).with({:text=>/Payment Information/})
                                   .and_return h2
    expect(h2).to receive(:wait_until_present)

    expect(subject).to receive(:screenshot).with(browser, "1")
    expect(subject).to receive(:screenshot).with(browser, "2")
  end

  it "should set the customer information" do
    expect(browser).to receive(:text).and_return('good response')

    expect(browser).to receive(:input).with({:id=>"accountId", :value=>''})
                                      .and_return input
    expect(browser).to receive(:input).with({:id=>"accountId"}).and_return input
    expect(input).to receive(:wait_while_present).with(30)
    expect(input).to receive(:value).and_return('123456789012')


    expect(subject.submit('my_email',
                           'my_password',
                          customer_details)).to eq '123456789012'
  end

  it "should raise and error if there is an error on the webpage" do
    expect(browser).to receive(:text).and_return('correct the error')

    expect(subject).to receive(:screenshot).with(browser, "error")

    expect{subject.submit('my_email', 'my_password', customer_details)}
        .to raise_error(StandardError,
                        'Aws returned error on the page when submitting customer information.')
  end
end
