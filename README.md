# Opto/Model

[![Build Status](https://travis-ci.org/kontena/opto-model.svg?branch=master)](https://travis-ci.org/kontena/opto-model)

Uses [Opto](https://github.com/kontena/opto/) as the engine to add validatable attributes and build nestable models from Ruby objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opto-model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opto-model

## Usage

See [Opto README](https://github.com/kontena/opto/blob/master/README.md) for attribute definition syntax reference.

### Defining models

```ruby
require 'opto-model'

class Name
  include Opto.model

  attribute :first_name, :string
  attribute :last_name, :string
end

class Person
  include Opto.model

  has_one :name, Name, required: true
  has_many :friends, Person

  attribute :age, :integer, min: 18
end
```

### Interacting with models (yes please)

#### Create an instance
```ruby
guy = Person.new
gal = Person.new(age: 20, name: { first_name: 'Elaine' }, friends: [guy])
```

#### Validating

```ruby
guy.valid?
=> false
guy.errors
=> { :name => { :presence => "Child missing: 'name'" }, :age => { :presence => "Required value missing" } }
```

#### Relations

Using another model:

```ruby
guy.name
=> nil
guy.name = Name.new(first_name: 'Guybrush', last_name: 'Threepwood')
guy.name.first_name
=> "Guybrush"
```

Using `new`:

```ruby
guy.name.new(first_name: 'Guybrush', last_name: 'Threepwood')
```

Using a hash:

```ruby
guy.name = {first_name: 'Guybrush', last_name: 'Threepwood'}
```

Using nested attributes:

```ruby
guy = Person.new(age: 18, name: { first_name: "Guybrush", last_name: "Threepwood" }, friends: [ { last_name: 'LeChuck' } ])
```

Also validates and collects errors for children:

```ruby
guy.valid?
=> false
guy.errors
=> { :friends => { 0 => { :first_name => { :presence => "Required value missing" } } } }
```

..unless told not to:

```ruby
guy.valid?(false)
=> true
guy.errors(false)
=> {}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kontena/opto-model.

