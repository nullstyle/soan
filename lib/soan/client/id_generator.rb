require 'uuid'

module Soan
  class Client::IdGenerator

    def initialize
      @uuid = ::UUID.new
    end

    def get
      @uuid.generate(:compact)
    end
  end
end