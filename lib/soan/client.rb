module Soan
  class Client
    include Celluloid

    autoload :Service,          "soan/client/service"
    autoload :ResponseListener, "soan/client/response_listener"
    autoload :IdGenerator,      "soan/client/id_generator"
    autoload :ResponseTicket,   "soan/client/response_ticket"

    def initialize(identity, bind_address)
      @services          = {}
      @response_listener = ResponseListener.new(identity, bind_address, self.current_actor)
      @id_generator      = IdGenerator.new
      @response_tickets  = {}

      @response_listener.link self.current_actor 
      @response_listener.async.run

    end

    def register_service(name)
      #TODO: raise argument error if the path doesn't end with a slash: so URI::Join works

      service = Service.new(name)
      @services[name] = service
    end

    def request(method, uri, body={}, headers={})
      uri     = URI(uri)
      service = find_service(uri)
      id      = @id_generator.get
      request = Request.new(id, method, uri.path, body, headers)
      request.respond_to = @response_listener

      service.async.req request

      @response_tickets[request.id] = ResponseTicket.new
    end

    def response_received(response)
      ticket = @response_tickets[response.id]
      return unless ticket
      ticket.resolve response
    end


    private
    def find_service(uri)
      @services[uri.host]
    end
  end
end