
```ruby
f = {}
f[:log_level]  = 'info'
f[:screenshots]  = File.expand_path("/var/temp/screenshots", File.dirname(__FILE__))

f[:account_name]  = 'The Munsters 01'
f[:account_email]  = 'adfasfasfsaf1@gmail.com'
f[:account_password]  = 'rJ87W7a[q72YBdX'


f[:customer_details] = { 'fullName'     => 'Hermen Munster',
                         'company'      => 'The Munsters',
                         'addressLine1' => '1313 Mockingbird Lane',
                         'city'         => 'Mockingbird Heights',
                         'state'        => 'CA',
                         'postalCode'   => '92000',
                         'phoneNumber'  => '(800) 555-1212',
                         'guess'        => 'Test Account' }

a = AwsAccountUtils::AwsAccountUtils.new(f)
resp = a.create_account
resp
```


 * Setting alternate contacts
 
 ** Request:
 
 set_alternate_contacts(hash_of_contacts)
 
 ** Response: (true/false)
 
 ** Example
 
 ```ruby
 resp = set_alternate_contacts({ 'operations'  => { 'name'        => 'Operations Name',
                                             'title'       => 'Operations Title',
                                             'email'       => 'operations@test.com',
                                             'phoneNumber' => '888-888-1212'},
                          'security'    => { 'name'        => 'Security Name',
                                             'title'       => 'Security Title',
                                             'email'       => 'Security@test.com',
                                             'phoneNumber' => '888-888-1212'}})

```



# AwsAccountUtils

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/aws_account_utils`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws_account_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
