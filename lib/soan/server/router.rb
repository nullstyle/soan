
module Soan
  class Server::Router
    attr_reader :routes

    def initialize(&block)
      @routes = Hash.new{[]}
      instance_exec &block
    end

    def route(method, path, constraints={}, &block)
      method = method.to_sym
      @routes[method] += [Route.new(method, path, constraints, block)]
    end

    def recognize(request)
      match = nil
      route = @routes[request.method].detect do |route| 
        match = route.matches request
      end
      [route, match]
    end

    def get(*args, &block)    ; route("get", *args, &block)     ; end
    def post(*args, &block)   ; route("post", *args, &block)    ; end
    def put(*args, &block)    ; route("put", *args, &block)     ; end
    def patch(*args, &block)  ; route("patch", *args, &block)   ; end
    def delete(*args, &block) ; route("delete", *args, &block)  ; end

  end

  class Route < Struct.new(:method, :path, :constraints, :block)
    attr_reader :regex

    def initialize(*args)
      super
      compile
    end

    def compile
      if path == "/"
        @regex = Regexp.new("^/$")
        return
      end

      segments = path.split "/"

      regex_string = segments.each_with_object("") do |s, result|
        next if s.blank?
        
        result << "/"

        result << if s.start_with? ":"
                    name = s[1..-1]
                    "(?<#{name}>[^/]+?)"
                  else
                    s
                  end
        @regex = Regexp.new("^#{result}$")
      end
    end

    def matches(request)
      match = path_matches(request)
      match if constraints_match?(request)
    end

    private
    def path_matches(request)
      @regex.match(request.path)
    end

    def constraints_match?(request)
      true
    end

  end

end