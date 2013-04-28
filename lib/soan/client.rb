module Soan
  class Client
    include Celluloid

    autoload :Service,          "soan/client/service"
    autoload :ResponseHandler,  "soan/client/response_handler"
    autoload :IdGenerator,      "soan/client/id_generator"

    def initialize(identity, bind_address)
      @services         = {}
      @response_handler = ResponseHandler.new(identity, bind_address, self.current_actor)
      @id_generator     = IdGenerator.new

      @response_handler.link self.current_actor 
      @response_handler.async.run
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
      request.respond_to = @response_handler

      service.async.req request      
    end

    def response_received(response)
      # look up request
      # if found, signal the value
    end


    private
    def find_service(uri)
      @services[uri.host]
    end
  end
end