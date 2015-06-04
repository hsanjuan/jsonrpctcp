require 'socket'
require 'json'
require 'jsonrpctcp/errors'

module Jsonrpctcp
  # The JSON-RPC client
  class Client
    attr_reader :host, :port

    # Initialize
    # @param host [String] a hostname or IP
    # @param port [String,Fixnum] a port number
    def initialize(host, port)
      @host = host
      @port = port
    end

    # @return [TrueClass,FalseClass] returns whether a 
    #                                response does not have an error key
    def self.success?(response)
      return !Client.is_error?(response)
    end

    # @return [TrueClass,FalseClass] returns whether a 
    #                                response does have an error key
    def self.is_error?(response)
      return response.has_key?('error')
    end

    # Allows to call RPC methods as if they were defined functions: 
    # client.mymethod(...)
    # @param method [Symbol] A RPC method name
    # @param args [Array] The arguments for the method are passed as
    #                     parameters to the function
    def method_missing(method, *args)
      return process_call(method, args)
    end

    # Calls an RPC methods in the client[:mymethod, "arg1",...] fashion
    # @param method [Symbol] A RPC method name
    # @param args [Array] The arguments for the method are passed as
    #                     parameters to the function
    def [](method, *args)
      return process_call(method, args)
    end

    # Generate a message id - currently the current time
    # @return [Fixnum] A time-based id
    def self.gen_id
      Time.now.to_i
    end

    private

    def process_call(method, args)
      call_obj = {
        'jsonrpc' => '2.0',
        'method' => method,
        'params' => args,
        'id' => Client.gen_id
      }

      call_obj_json = call_obj.to_json
      begin
        socket = TCPSocket.open(@host, @port)
        socket.write(call_obj_json)
        socket.close_write()
        response = socket.read()
        parsed_response = JSON.load(response)
      rescue JSON::ParserError
        raise RPCException.new("RPC response could not be parsed")
      ensure
        socket.close()
      end

      if Client.is_error?(parsed_response)
        raise RPCError.from_rpc_response(parsed_response)
      else
        return parsed_response
      end
    end
  end
end
