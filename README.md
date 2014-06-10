# FormhubRuby

A very simple Ruby Wrapper for the Formhub API

## Installation

Add this line to your application's Gemfile:

    gem 'formhub_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install formhub_ruby

## Usage

### Basic usage
This gem is a very simple API wrapper for the JSON API of [Formhub
](https://formhub.org/) application.
More details on their JSON API can be foud on their [wiki page]( https://github.com/SEL-Columbia/formhub/wiki/Formhub-Access-Points-(API)).


### Set a connection with the Formhub API

Create a connection like so:

    connection = FormhubRuby::ApiConnector.new(username: 'fake_username', password: 'fake_password', formnamne: 'my_form_name' )

You can also pass authentification configuration arguments in a block (e.g. in a initializer file, etc...):

    FormhubRuby.configure do |config|
      config.username =  'fake_username'
      config.password =  'fake_password'
    end

To get the actual data from the api call, call the fetch method on it:

    connection.fetch

You should then be able to retrieve an array of hashes by using the data method

    the_result = connection.data 
    the_result.first.name
    # => Loic

If only want the actual count of rows is needed, use the count method:

    connection.count
    # => 4

Before fetching, a more refined query can be created by using a hash of queries:
    
    connection.query = {age: 12}

You can set a start and limit for the rows returned
    
    connection.start = 2
    connection.limit = 2

and select the fields to be retrieved:
    
    connection.fields = [:age, :name]

Finally you can also sort the results:  1 denotes an ascending sort while -1 denotes a descending sort:

    connection.sort =  {name: -1} # Descending by name
    connection.sort =  {name: 1} # Ascending by name

As far as I could tell though, the integers seem to be stored as strings in the Formhub database, so the sorting of these would be quite irrelevant.

Also consequently added: a parameter to cast integers types:
		
		connection.cast_integers = true # false by default

Be aware that this will also cast float values to integer values.


## Contributing

1. Fork it ( http://github.com/<my-github-username>/formhub_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
