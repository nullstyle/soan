module Soan
  class Server
    autoload :ResponseChannel,  "soan/server/response_channel"
    autoload :Application,      "soan/server/application"
    autoload :Router,           "soan/server/router"

    include Celluloid::ZMQ

    def self.make(identity, bind_address, &block)
      app = Application.new(&block)
      new(identity, bind_address, app)
    end


    def initialize(identity, bind_address, application)
      @socket            = PullSocket.new
      @response_channels = {}
      @socket.identity   = "soan-server-#{identity}"
      @bind_address      = bind_address
      @application       = application
    end

    def bind
      begin
        @socket.bind(@bind_address)
      rescue IOError
        @socket.close
        raise
      end
    end

    def run
      run_once
      self.current_actor.async.run # uses async calls to loop on itself
    end

    private
    def get_response_channel(address)
      @response_channels[address] ||= ResponseChannel.new(address)
    end


    def run_once
      request_message = @socket.read

      request = PROTOCOL.request_from_bytes(request_message)

      response = @application.dispatch(request)

      respond_to = request.respond_to
      if respond_to.present?
        ch = get_response_channel(respond_to)
        ch.async.resp response
      end
    end

  end
end