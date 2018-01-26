# coding: utf-8
# Copyright (C) 2015 Hector Sanjuan

# This file is part of Jsonrpctcp.

# Jsonrpctcp is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Jsonrpctcp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Jsonrpctcp.  If not, see <http://www.gnu.org/licenses/>

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonrpctcp/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonrpctcp"
  spec.version       = Jsonrpctcp::VERSION
  spec.authors       = ["Hector Sanjuan"]
  spec.email         = ["hector@convivencial.org"]

  spec.summary       = 'A very simple JSON-RPC 2.0 client library using plain old TCP sockets'
  spec.description   = <<EOF
jsonrpctcp provides a simple JSON-RPC 2.0 synchronous client. Everytime a command is sent, it will open a TCPSocket, send it and read the response. 
EOF
  spec.license       = "GPLv3+"
  spec.homepage      = "https://github.com/hsanjuan/jsonrpctcp"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "simplecov", "~> 0.14"
  spec.add_development_dependency "coveralls", "~> 0.8"
end
