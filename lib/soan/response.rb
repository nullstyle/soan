module Soan
  class Response
    
    attr_reader :id, :code, :body, :headers

    def initialize(id, code, body={}, headers={})
      @id = id
      @code = code
      @body = body
      @headers = headers
    end
  end
end