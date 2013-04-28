module Soan
  class Server::ResponseChannel
    include Celluloid::ZMQ

    attr_reader :response_address

    def initialize(response_address)
      Soan.init
      @response_address = response_address
      @socket = PushSocket.new
      @socket.identity = response_address
      @socket.linger = 300 # wait for up to 300ms before quitting
      connect
    end

    def resp(response)
      @socket.write(PROTOCOL.response_to_bytes(response))
    end

    private
    def connect
      begin
        @socket.connect(response_address)
      rescue IOError
        @socket.close
        raise
      end
    end

  end
end