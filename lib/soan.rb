require "soan/version"
require 'celluloid'
require 'celluloid/zmq'
require 'soan/celluloid_ext/actor_proxy/safe_inspect'
require 'soan/core_ext/match_data/to_hash'
require 'active_support/core_ext/hash'

module Soan
  autoload :Request, "soan/request"
  autoload :Response, "soan/response"
  
  autoload :Client, "soan/client"
  autoload :CallSupervisor, "soan/call_supervisor"

  autoload :Server, "soan/server"

  module Protocol
    autoload :MsgPackProtocol, "soan/protocol/msgpack"
  end

  PROTOCOL = Protocol::MsgPackProtocol.new #TODO: configurability

  def self.init
    Celluloid::ZMQ.init
  end
end

Soan.init
