require 'spec_helper'

describe AwsAccountUtils::ChallengeQuestions do
  let(:logger) { Logger.new(STDOUT) }
  let(:subject) { AwsAccountUtils::ChallengeQuestions.new logger, browser }
  let(:browser) { double 'browser' }
  let(:a) { double 'browser element a' }
  let(:div) { double 'browser element div' }
  let(:input) { double 'browser input' }
  let(:button) { double 'browser button' }
  let(:text_field) { double 'browser text field' }
  let(:url) { 'https://portal.aws.amazon.com/gp/aws/manageYourAccount' }

  it "should set the answers to the security questions" do
    expect(logger).to receive(:debug).with('Setting security challenge answers.')
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
                           .with({:xpath=>"//a[@ng-click=\"toggleEditingSecurityQuestionsInfoState()\"]"})
                           .and_return a
    expect(a).to receive(:when_present).and_return a
    expect(a).to receive(:click)

    expect(browser).to receive(:input)
                   .with({:xpath => "//input[@ng-model=\"selectedSecurityQuestions.question1.answer\"]"})
                   .and_return input

    expect(browser).to receive(:input)
                   .with({:xpath => "//input[@ng-model=\"selectedSecurityQuestions.question2.answer\"]"})
                   .and_return input

    expect(browser).to receive(:input)
                   .with({:xpath => "//input[@ng-model=\"selectedSecurityQuestions.question3.answer\"]"})
                   .and_return input
    expect(input).to receive(:to_subtype).exactly(3).times.and_return input
    expect(input).to receive(:when_present).exactly(3).times.and_return input
    expect(input).to receive(:set).exactly(3).times

    expect(browser).to receive(:button)
                   .with({:xpath=>"//button[@ng-click=\"updateSecurityQuestions()\"]"})
                   .and_return button
    expect(button).to receive(:when_present).and_return button
    expect(button).to receive(:click)

    expect(browser).to receive(:a)
                           .with({:xpath=>"//a[@ng-click=\"toggleEditingSecurityQuestionsInfoState()\"]"})
                           .and_return a
    expect(a).to receive(:wait_until_present)


    expect(subject.create('my_user',
                          'my_password',
                          {1 => 'answer1',
                           2 => 'answer2',
                           3 => 'answer3'})).to eq({1=>"answer1",
                                                    2=>"answer2",
                                                    3=>"answer3"})

  end
end