[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/intuit/aws_account_utils?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/intuit/aws_account_utils.svg?branch=feature_delete_account)](https://travis-ci.org/intuit/aws_account_utils)
[![Coverage Status](https://coveralls.io/repos/intuit/aws_account_utils/badge.svg?branch=feature_delete_account&service=github)](https://coveralls.io/github/intuit/aws_account_utils)
[![Gem Version](https://badge.fury.io/rb/aws_account_utils.svg)](https://badge.fury.io/rb/aws_account_utils)
[![Code Climate](https://codeclimate.com/github/intuit/aws_account_utils.png)](https://codeclimate.com/github/intuit/aws_account_utils)

# AwsAccountUtils

[![Join the chat at https://gitter.im/intuit/aws_account_utils](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/intuit/aws_account_utils?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A collection of helpers for creating and modifying AWS account details that can not be done using any existing AWS API

Special Note: the `create_account` operation requires that your IP be white-listed by AWS in order to bypass the CAPTCHA

## Installation

NOTE: Ruby 2.2 is required!

Add this line to your application's Gemfile:

```ruby
gem 'aws_account_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_account_utils

## Usage

Overview
=================

If you are required to go through a proxy, the following should be set prior to execution.
```
export no_proxy=127.0.0.1
export http_proxy=myproxyhots.com
```

```ruby
aws_utils = AwsAccountUtils::AwsAccountUtils.new(
  browser: (Watir::Browser) - default: Watir Browser object - You can pass in your own Browser object or use the built-in which uses firefox.
  logger: (Logger) - default: Logger object. - You can pass in your own logger or use the built in.
  log_level: (Symbol) - default: :info - Sets the logger level. Only :info and :debug are useful
  screenshots: (String) - default: nil - Enables screenshots by passing the directory to put the screenshots which are taken throughout the different operations. 
 )
```

 Operations
=================
  * [create_account](#create_account)
  * [change_root_password](#change_root_password)
  * [check_enterprise_support](#check_enterprise_support)
  * [confirm_consolidated_billing](#confirm_consolidated_billing)
  * [create_root_access_keys](#create_root_access_keys)
  * [delete_root_access_keys](#delete_root_access_keys)
  * [email_opt_out](#email_opt_out)
  * [enable_enterprise_support](#enable_enterprise_support)
  * [enable_iam_billing](#enable_iam_billing)
  * [logout_from_console](#logout_from_console)
  * [request_consolidated_billing](#request_consolidated_billing)
  * [set_alternate_contacts](#set_alternate_contacts)
  * [set_challenge_questions](#set_challenge_questions)
  * [set_company_name](#set_company_name)

create_account
------------

> Creates a new AWS Account and with the minimal amount of information and 
> returns the account number of the new account.
> Requires that your IP be white-listed by AWS in order to bypass the CAPTCHA

`#create_account(account_name:, account_email, account_password:, account_details:)`

**Examples:**
```Ruby
details = { 'fullName'     => 'Herman Munster',
            'company'      => 'The Munsters',
            'addressLine1' => '1313 Mockingbird Lane',
            'city'         => 'Mockingbird Heights',
            'state'        => 'CA',
            'postalCode'   => '92000',
            'phoneNumber'  => '(800) 555-1212',
            'guess'        => 'Test Account' }

resp = aws_utils.create_account(account_name: 'My Test Account 01',
                                account_email: 'adfefef@gmail.com',
                                account_password: 'foobar1212121',
                                account_details: details)
resp #=> String
```

**Parameters:**
```
account_name: (required, String) - The account name to associate with this new account
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
account_details: (required, Hash) - Hash of account details
```

**Returns:**

`1234-1223-1242 #Accont Number => String`

change_root_password
------------

> Changes the account password

`change_root_password(account_email:, account_password:, new_password:)`

**Examples:**
```Ruby
resp = aws_utils.change_root_password(account_email: 'adfefef@gmail.com',
                                      account_password: 'foobar1212121',
                                      new_password: 'mynewpassword')
resp #=> true/false
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The old password to use with this new account
new_password: (required, String) - The new password to use with this new account
```

**Returns:**

`#return => Boolean`

---

check_enterprise_support
------------

> Checks if enterprise support is enabled

`check_enterprise_support(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.check_enterprise_support(account_email: 'adfefef@gmail.com',
                                          account_password: 'foobar1212121'')
resp #=> true/false
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

confirm_consolidated_billing
------------

> Confirms consolidated billing by taking the link that was emailed to you when you enabled consolidated billing.

`confirm_consolidated_billing(account_email:, account_password:, confirmation_link:)`

**Examples:**
```Ruby
resp = aws_utils.confirm_consolidated_billing(account_email: 'adfefef@gmail.com',
                                              account_password: 'foobar1212121',
                                              confirmation_link: 'amazonaws.com/confirmationlink')
resp #=> nil
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
confirmation_link: (required, String) - The unique url that will confirm billing

```

**Returns:**

`#return => nil`

---

create_root_access_keys
------------

> Creates access and secret key for root account

`create_root_access_keys(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.create_root_access_keys(account_email: 'adfefef@gmail.com',
                                         account_password: 'foobar1212121)
resp #=> Hash
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Hash {:access_key=>"my_access_key", :secret_key=>"my_secret_key"}`

---

delete_root_access_keys
------------

> Deletes ALL root access/secret keys from the root of the account

`delete_root_access_keys(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.delete_root_access_keys(account_email: 'adfefef@gmail.com',
                                         account_password: 'foobar1212121)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => true/false`

---

email_opt_out
------------

> Opts account out of all email marketing

`email_opt_out(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.email_opt_out(account_email: 'adfefef@gmail.com',
                               account_password: 'foobar1212121)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

enable_enterprise_support
------------

> Enables enterprise support, this should be done after consolidated billing has been setup

`enable_enterprise_support(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.enable_enterprise_support(account_email: 'adfefef@gmail.com',
                                           account_password: 'foobar1212121)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

enable_iam_billing
------------

> Sets the account to enable IAM billing

`enable_iam_billing(account_email:, account_password:)`
**Examples:**
```Ruby
resp = aws_utils.enable_iam_billing(account_email: 'adfefef@gmail.com',
                                    account_password: 'foobar1212121)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

existing_consolidated_billing
------------

> Checks to see if consolidated billing has been setup

`existing_consolidated_billing?(account_email:, account_password:)`

**Examples:**
```Ruby
resp = aws_utils.existing_consolidated_billing?(account_email: 'adfefef@gmail.com',
                                                account_password: 'foobar1212121)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

logout_from_console
------------

> Logs out of the console

`logout_from_console`

**Examples:**
```Ruby
resp = aws_utils.logout_from_console
resp #=> True/False
```

**Parameters:**
```
```

**Returns:**

`#return => Boolean`

---

request_consolidated_billing
------------

> Requests consolidated billing to be setup with your master account. An email is sent to the 
> account being added with a link. That link should be passed into `confirm_consolidated_billing`

`request_consolidated_billing(master_account_email:, master_account_password:, account_email:)`

**Examples:**
```Ruby
resp = aws_utils.request_consolidated_billing(master_account_email: 'my_master_acccount@gmail.com',
                                              master_account_password: 'master_acct_password,
                                              account_email: 'my_new_account_email@gmail.com')
resp #=> True/False
```

**Parameters:**
```
master_account_email: (required, String) - The email for your master billing aws account
master_account_password: (required, String) - The password for your master billing aws account
account_email: (required, String) - The email for the account you want to add to consolidated billing under the master account
```

**Returns:**

`#return => Boolean`

---

set_alternate_contacts
------------

> Sets alternate contacts for the account

`set_alternate_contacts(account_email:, account_password:, contact_info:)`

**Examples:**
```Ruby

contacts = {'operations' => {'name' => 'Operations Name',
                             'title' => 'Operations Title',
                             'email' => 'operations@test.com',
                             'phoneNumber' => '888-888-1212'},
            'security' => {'name' => 'Security Name',
                           'title' => 'Security Title',
                           'email' => 'Security@test.com',
                           'phoneNumber' => '888-888-1212'}}
                                     
resp = aws_utils.set_alternate_contacts(account_email: 'adfefef@gmail.com',
                                        account_password: 'foobar1212121,
                                        contact_info: contacts)
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
contact_info: (required, Hash) - A Hash of Hash of contacts, operations, security, etc.

```

**Returns:**

`#return => Boolean`

---

set_challenge_questions
------------

> Sets the accounts challenge security questions

`set_challenge_questions(account_email:, account_password:, answers:)`

**Examples:**
```Ruby
my_answers = {1 => 'answer1',
              2 => 'answer2',
              3 => 'answer3'}
              
resp = aws_utils.set_challenge_questions(account_email: 'adfefef@gmail.com',
                                         account_password: 'foobar1212121,
                                         answers: my_answers)
                                        
resp #=> {1 => 'answer1', 2 => 'answer2', 3 => 'answer3'}
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
answers: (optional, Hash) - A hash of answers to fill in for the security questions. If you dont pass your own, Random word will generate for you.

```

**Returns:**

`#return => Hash`

---

set_company_name
------------

> Sets company name for the account (any time after account is created)

`set_company_name(account_email:, account_password:, company_name:)`

**Examples:**
```Ruby
                                     
resp = aws_utils.set_alternate_contacts(account_email: 'adfefef@gmail.com',
                                        account_password: 'foobar1212121,
                                        company_name: 'The Munsters, Inc.')
resp #=> True/False
```

**Parameters:**
```
account_email: (required, String) - The email to associate with this account
account_password: (required, String) - The password to use with this account
contact_info: (required, String) - The company name to add to this account

```

**Returns:**

`#return => Boolean`

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws_account_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
