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

**create_account**

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

---

`change_root_password(account_email:, account_password:, new_password:)`

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
