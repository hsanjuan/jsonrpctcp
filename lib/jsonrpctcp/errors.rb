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

module Jsonrpctcp

  # A custom exception for the library
  class RPCException < Exception
  end

  # A custom error for the library
  class RPCError < StandardError
    attr_reader :code, :message, :source_object
    # RPC erros allow quick access to the code, the message and the 
    # source error object returned by the server
    # @param message [String] Error message
    # @param code [Fixnum] Error code
    # @param source [Hash] Original error object
    def initialize(message, code, source)
      @code = code
      @message = message
      @source_object = hash
    end

    # Creates a RPCError directly from a RPC response
    # @param r [Hash] a parsed response
    def self.from_rpc_response(r)
      return RPCError.new(r['error']['message'],
                          r['error']['code'], 
                          r)
    end
  end
end
