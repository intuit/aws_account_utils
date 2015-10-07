require 'spec_helper'

describe AwsAccountUtils::RootAccessKeys do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::RootAccessKeys.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:label) { double 'browser label' }
  let(:div) { double 'browser div' }
  let(:element) { double 'browser element' }
  let(:i) { double 'browser i' }
  let(:a) { double 'browser a' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:warning_text) { 'You are accessing the security credentials page for your AWS account. The account credentials provide unlimited access to your AWS resources.'}
  let(:url) { 'https://console.aws.amazon.com/iam/home?#security_credential' }

  it "should create secret/access keys" do
    expect(logger).to receive(:debug).with('Creating root access/secret key')
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
    expect(browser).to receive(:url).and_return('https://www.amazon.com/ap/signin?')
    expect(logger).to receive(:debug).with('Logging into AWS.')

    expect(browser).to receive(:div)
                   .with({:id => 'modal-content', :text => warning_text})
                   .and_return label
    expect(label).to receive(:wait_until_present)

    expect(browser).to receive(:label)
                   .with({:text => /Don't show me this message again/}).and_return label

    expect(browser).to receive(:element).with({:id => 'continue'}).and_return element
    expect(element).to receive(:when_present).and_return element
    expect(element).to receive(:click)

    expect(browser).to receive(:i)
                   .with({:xpath => "id('credaccordion')/div[3]/div[1]/div/div[1]/i"})
                   .and_return i
    expect(i).to receive(:when_present).and_return i
    expect(i).to receive(:click)

    expect(browser).to receive(:button).with({:text => /Create New Access Key/})
                                       .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:a).with({:text => /Show Access Key/}).and_return a
    expect(a).to receive(:when_present).and_return a
    expect(a).to receive(:click)

    expect(browser).to receive(:text)
                   .and_return "my_access_key\n\nmy_secret_key\nA bunch of words\n"

    expect(subject.create('my_user', 'my_password'))
        .to eq({:access_key=>"my_access_key", :secret_key=>"my_secret_key"})
  end
end