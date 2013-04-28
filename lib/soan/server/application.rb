module Soan
  class Server::Application

    NOT_FOUND = 404

    attr_reader :request
    attr_reader :params
    attr_reader :route
    attr_reader :route_matches


    def initialize(&block)
      @routes = Server::Router.new &block
    end

    def dispatch(request)

      @request = request
      @route, @route_matches = @routes.recognize(request)
      
      return retval_into_response(NOT_FOUND) unless @route

      @params = make_params
      retval = instance_exec &@route.block

      retval_into_response(retval)
    end
    

    private
    def retval_into_response(retval)
      (code, body, headers) =  
        case retval
        when Hash ; 
          [nil, retval, nil]
        when Array ; 
          [retval[0], retval[1], retval[2]]
        when String ; 
          [nil, {"message" => retval}, nil]
        when Symbol ;
          [symbol_into_code(retval), nil, nil]
        when Fixnum ;
          [retval, nil, nil]
        else ; 
          raise ArgumentError, "Invalid response"
        end

      code    ||= 200
      body    ||= {}
      headers ||= {}

      Response.new(request.id, code, body, headers)
    end

    def make_params
      {} #TODO
    end

    def symbol_into_code(sym)
      200 #TODO
    end
  end
end