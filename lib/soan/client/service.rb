module Soan
  class Client::Service
    include Celluloid::ZMQ

    attr_reader :name

    def initialize(name)
      @name = name
      @socket = PushSocket.new
      @socket.linger = 0 # don't wait to exit for pending requests
    end

    def connect(address)
      begin
        @socket.connect(address)
      rescue IOError
        @socket.close
        raise
      end
    end

    def req(request)
      messages = []
      @socket.write(PROTOCOL.request_to_bytes(request))
    end
  end
end