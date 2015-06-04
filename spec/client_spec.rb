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
  end
end
