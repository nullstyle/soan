module Soan
  class Client::ResponseTicket

    def initialize
      @queue = Queue.new
    end

    def resolve(response)
      @queue << response
    end

    def value
      @queue.pop
    end

  end
end