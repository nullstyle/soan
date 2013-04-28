module Soan
  class Client::ResponseHandler
    include Celluloid::ZMQ

    attr_reader :bind_address

    def initialize(identity, bind_address, upstream)
      @socket          = PullSocket.new
      @socket.identity = "soan-response_handler-#{identity}"
      @bind_address    = bind_address
      @upstream        = upstream
      bind
    end

    def run
      run_once
      self.current_actor.async.run
    end

    def run_once
      message  = @socket.read
      response = PROTOCOL.response_from_bytes(message)
      @upstream.async.response_received response
    end

    private
    def bind
      begin
        @socket.bind(@bind_address)
      rescue IOError
        @socket.close
        raise
      end
    end

  end
end