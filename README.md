# AwsAccountUtils

A collection of helpers for creating and modifying AWS account details that can not be done using any existing AWS API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_account_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_account_utils

## Usage

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

create_account
------------

> Creates a new AWS Account and with the miminal amount of information and 
> returns the account number of the new account.

`#create_account(account_name:, account_email, account_password:, account_details:)`

**Examples:**
```Ruby
details = { 'fullName'     => 'Hermen Munster',
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

**Paramaters:**
```
account_name: (required, String) - The account name to associate with this new account
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
account_details: (required, Hash) - Hash of account deatails
```

**Returns:**

`1234-1223-1242 #Accont Number => String`

**change_root_password**

> Changes the account password

`change_root_password(account_email:, account_password:, new_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The old password to use with this new account
new_password: (required, String) - The new password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**change_root_password**

> Changes the account password

`check_enterprise_support(account_email:, account_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**change_root_password**

> Changes the account password

`confirm_consolidated_billing(account_email:, account_password:, confirmation_link:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**create_root_access_keys**

> Creates access and secret key for root account

`create_root_access_keys(account_email:, account_password:)`
**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**delete_root_access_keys**

> Deletes ALL root access/secret keys from the root of the account

`delete_root_access_keys(account_email:, account_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**email_opt_out**

> Opts account out of all email marketing

`email_opt_out(account_email:, account_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**enable_enterprise_support**

> Enables enterprise support

`enable_enterprise_support(account_email:, account_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**enable_iam_billing**

> Sets the account to enable IAM billing

`enable_iam_billing(account_email:, account_password:)`
**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**existing_consolidated_billing**

> Checks to see if consolidated billing has been setup

`existing_consolidated_billing?(account_email:, account_password:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**logout_from_console**

> Logs out of the console

`logout_from_console`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**request_consolidated_billing**

> Requests consolidated billing to be setup with your master account. An email is sent to the 
> account being added with a link. That link should be passed into `confirm_consolidated_billing`

`request_consolidated_billing(master_account_email:, master_account_password:, account_email:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**set_alternate_contacts**

> Sets alternate contacts for the account

`set_alternate_contacts(account_email:, account_password:, contact_info:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
```

**Returns:**

`#return => Boolean`

---

**set_challenge_questions**

> Sets the accounts challenge security questions

`set_challenge_questions(account_email:, account_password:, answers:)`

**Examples:**
```Ruby

resp #=> String
```

**Paramaters:**
```
account_email: (required, String) - The email to associate with this new account
account_password: (required, String) - The password to use with this new account
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
