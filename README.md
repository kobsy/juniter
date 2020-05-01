# Juniter
![Tests](https://github.com/kobsy/juniter/workflows/Tests/badge.svg)

A simple Ruby library for parsing and working with JUnit files

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'juniter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install juniter

## Usage

Load a JUnit XML file into Juniter using one of the following methods:

```ruby
Juniter.read(io_stream)
# => <Juniter::File>

Juniter.from_file(file_name)
# => <Juniter::File>

Juniter.parse(xml_string)
# => <Juniter::File>
```

From there, you can traverse the JUnit hierarchy via named methods. E.g.,

```ruby
file = Juniter.parse(xml)
failures = file.test_suites.test_suites.first.test_cases.select(&:fail?)
puts failures.map { |failure| failure.message }.join("\n")
```

Juniter uses [ox](https://github.com/ohler55/ox) under the hood for its XML parsing. You can get at the parsed Ox elements via `juniter_file.parsed_xml`

Juniter can also reassemble the objects into an XML file:

```ruby
juniter_file.to_xml
# => "<?xml version="1.0" encoding="UTF-8"><testsuites> ..."
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kobsy/juniter.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

