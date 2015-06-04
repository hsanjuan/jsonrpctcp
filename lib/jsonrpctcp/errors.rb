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
