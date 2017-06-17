# Bruv

Write Ruby classes with less code. Bruv is a simple module which adds helper methods for defining class instance variables with reader methods and optional procs for processing data. Also defines an `initialize` method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bruv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bruv

## Usage

Just include the module into a class and use `attribute` and `attributes` to define class instance variables like:
```ruby
class MyClass
  include Bruv
  attribute :name
  attribute :tag, ->(d) { d.capitalize }
  attributes :type, :category
end

mc = MyClass.new('Hammer', 'bargain', 'tools', 'basic')
mc.name     # => 'Hammer'
mc.tag      # => 'Bargain'
mc.type     # => 'tools'
mc.category # => 'basic'

# or

mc = MyClass.new('Hammer', 'bargain')
mc.name     # => 'Hammer'
mc.date     # => 'Bargain'
mc.type     # => nil
mc.category # => nil
```

In case the number of arguments passed into `initialize` is greater than the number of instance variables defined with `argument` and `arguments` methods a BruvArgumentError is raised.

```ruby
class MyClass
  include Bruv
  attributes :type, :category
end

MyClass.new('tools', 'basic', 'bargain') # => Bruv::BruvArgumentError: Number of arguments exceeds number of instance variables.
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
