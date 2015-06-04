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

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jsonrpctcp/client'
include Jsonrpctcp


describe Client do
  let(:standard_response){
    {"jsonrpc" => "2.0", "result" => 19, "id" => 1}.to_json
  }

  let(:error_response){
    {
      "jsonrpc" => "2.0",
      "error" => {"code" => -32600, "message" => "Invalid Request"},
      "id" => nil
    }.to_json
  }

  let(:client) {
    Client.new("host", "123")
  }

  let(:socket) {
    double("socket")
  }

  before :each do
    allow(Client).to receive(:gen_id).and_return(1)
    allow(TCPSocket).to receive(:open).with("host", "123").and_return(socket)
  end

  describe "#initialize" do
    it "should set @host and @port" do
      expect(client.host).to eq("host")
      expect(client.port).to eq("123")
    end
  end

  describe "#success" do
    it "should tell success from error" do
      expect(Client.success?({'jsonrpc' => '2.0'})).to be(true)
      expect(Client.success?({'jsonrpc' => '2.0', 'error' => {}})).to be(false)
    end
  end

  describe "#[]" do
    it "should correctly do a process call when a method is not defined" do
      expect(socket).to receive(:write).with({
                                               'jsonrpc' => '2.0',
                                               'method' => 'mymethod',
                                               'params' => ['myarg', 'myarg2'],
                                               'id' => 1
                                             }.to_json)
      expect(socket).to receive(:close_write)
      expect(socket).to receive(:read).and_return(standard_response)
      expect(socket).to receive(:close)
      r = client.mymethod("myarg", "myarg2")
      expect(r).to eq(JSON.load(standard_response))
    end

    it "should correctly do a process call" do
      expect(socket).to receive(:write).with({
                                               'jsonrpc' => '2.0',
                                               'method' => 'mymethod',
                                               'params' => ['myarg', 'myarg2'],
                                               'id' => 1
                                             }.to_json)
      expect(socket).to receive(:close_write)
      expect(socket).to receive(:read).and_return(standard_response)
      expect(socket).to receive(:close)
      r = client[:mymethod, "myarg", "myarg2"]
      expect(r).to eq(JSON.load(standard_response))
    end

    it "should raise RPCException if JSON Could not be parsed" do
      expect(socket).to receive(:write).with({
                                               'jsonrpc' => '2.0',
                                               'method' => 'mymethod',
                                               'params' => ['myarg', 'myarg2'],
                                               'id' => 1
                                             }.to_json)
      expect(socket).to receive(:close_write)
      expect(socket).to receive(:read).and_return('{asdf};lkjahnse')
      expect(socket).to receive(:close)
      expect {
        client[:mymethod, "myarg", "myarg2"]
      }.to raise_exception(RPCException)
    end

    it "should raise an RPCError if RPC returns an error" do
      expect(socket).to receive(:write).with({
                                               'jsonrpc' => '2.0',
                                               'method' => 'mymethod',
                                               'params' => ['myarg', 'myarg2'],
                                               'id' => 1
                                             }.to_json)
      expect(socket).to receive(:close_write)
      expect(socket).to receive(:read).and_return(error_response)
      expect(socket).to receive(:close)
      expect {
        client[:mymethod, "myarg", "myarg2"]
      }.to raise_exception(RPCError)
    end

    it "should cleanly fail if TCP open raises exception" do
      expect(TCPSocket).to receive(:open).and_raise(Exception)
      expect(socket).not_to receive(:close)
      expect {
        client[:mymethod, "myarg", "myarg2"]
      }.to raise_exception(Exception)
    end
  end
end
