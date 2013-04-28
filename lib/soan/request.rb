module Soan
  class Request
    
    attr_reader :id, :method, :path, :body, :headers

    def initialize(id, method, path, body={}, headers={})
      @id = id
      @method = method
      @path = path
      @body = body
      @headers = headers
    end

    def respond_to=(response_handler)
      @headers[:respond_to] = response_handler.bind_address
    end

    def respond_to
      @headers[:respond_to]
    end
  end
end