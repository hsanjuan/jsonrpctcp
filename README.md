# Jsonrpctcp

[![Gem Version](https://badge.fury.io/rb/jsonrpctcp.svg)](http://badge.fury.io/rb/jsonrpctcp) [![Build Status](https://travis-ci.org/hsanjuan/jsonrpctcp.svg)](https://travis-ci.org/hsanjuan/jsonrpctcp) [![Coverage Status](https://coveralls.io/repos/hsanjuan/jsonrpctcp/badge.svg)](https://coveralls.io/r/hsanjuan/jsonrpctcp)

A very simple JSON-RPC 2.0 client library using plain old TCP (`TCPSocket`) for the communication (no HTTP).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonrpctcp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonrpctcp

## Usage

```ruby
require 'jsonrpctcp'

client = Jsonrpctcp::Client.new("host", 1234)
client.mymethod("arg1", "arg2")
client.myothermethod("arg1")
client[:yetonemethod, "arg"]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hsanjuan/jsonrpctcp.

