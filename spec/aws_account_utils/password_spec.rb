require 'spec_helper'

describe AwsAccountUtils::Password do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::Password.new logger, browser }
  let(:login) { AwsAccountUtils::Login.new logger, browser }
  let(:browser) { double 'browser' }
  let(:h1) { double 'browser element h1' }
  let(:h6) { double 'browser element h6' }
  let(:div) { double 'browser div' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:error_header) { "There was a problem with your request" }
  let(:error_body)   { "invalid password" }
  let(:url) { url = "https://www.amazon.com/ap/cnep?_encoding=UTF8"
              url<< "&openid.assoc_handle=aws"
              url<< "&openid.return_to=https%3A%2F%2Fconsole.aws.amazon.com%2Fbilling%2Fhome%23%2Faccount"
              url<< "&openid.mode=id_res&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
              url<< "&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select"
              url<< "&openid.pape.max_auth_age=600"
              url<< "&openid.pape.preferred_auth_policies=http%3A%2F%2Fschemas.openid.net%2Fpape%2Fpolicies%2F2007%2F06%2Fmulti-factor-physical"
              url<< "&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0"
              url<< "&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select" }

  it "should change the master account password" do
    expect(logger).to receive(:debug).with('Changing root password.')
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

    expect(browser).to receive(:h1).with({:text => /Change Name, E-mail Address, or Password/}).and_return h1
    expect(h1).to receive(:wait_until_present)

    expect(browser).to receive(:button).with({:id => 'cnep_1A_change_password_button-input'}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:text_field).with({:id => "ap_password"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password_new"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password_new_check"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:id => "cnep_1D_submit_button-input"}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:div).with({:id=>/message_(error|warning)/}).and_return div
    expect(div).to receive(:exist?).and_return false

    expect(browser).to receive(:h6).with({:text => /Success/}).and_return h6
    expect(h6).to receive(:exist?).and_return true

    expect(subject.change('my_user', 'my_old_password', 'my_new_password')).to be true
  end

  it "should change the master account password" do
    expect(logger).to receive(:debug).with('Changing root password.')
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

    expect(browser).to receive(:h1).with({:text => /Change Name, E-mail Address, or Password/}).and_return h1
    expect(h1).to receive(:wait_until_present)

    expect(browser).to receive(:button).with({:id => 'cnep_1A_change_password_button-input'}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:text_field).with({:id => "ap_password"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password_new"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:text_field).with({:id => "ap_password_new_check"}).and_return text_field
    expect(text_field).to receive(:when_present).and_return text_field
    expect(text_field).to receive(:set)

    expect(browser).to receive(:button).with({:id => "cnep_1D_submit_button-input"}).and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:div).with(:id => /message_(error|warning)/)
                           .and_return(browser)
    expect(browser).to receive(:exist?).and_return(true)
    expect(subject).to receive(:screenshot).with(browser, "1")
    expect(subject).to receive(:screenshot).with(browser, "2")
    expect(subject).to receive(:screenshot).with(browser, "3")
    expect(subject).to receive(:screenshot).with(browser, "error")
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/)
                           .and_return(browser)
    expect(browser).to receive(:h6).and_return(browser)
    expect(browser).to receive(:text).and_return(error_header)
    expect(browser).to receive(:div).with(:id => /message_(error|warning)/)
                           .and_return(browser)
    expect(browser).to receive(:p).and_return(browser)
    expect(browser).to receive(:text).and_return(error_body)

    expect{subject.change('my_user', 'my_old_password', 'my_new_password')}
        .to raise_error(StandardError,
                        "AWS Password Change Error: \"#{error_header}: #{error_body}\"")
  end
end