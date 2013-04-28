require 'ffi/msgpack'

module Soan
  module Protocol
    class MsgPackProtocol

      def request_to_bytes(request)
        message = { id: request.id, method: request.method, path: request.path }
        message[:body] = request.body unless request.body.blank?
        message[:headers] = request.headers unless request.headers.blank?
        FFI::MsgPack.pack(message)
      end

      def response_to_bytes(response)
        message = { id: response.id, code: response.code }
        message[:body] = response.body unless response.body.blank?
        message[:headers] = response.headers unless response.headers.blank?
        FFI::MsgPack.pack(message)
      end

      def request_from_bytes(bytes)
        message = FFI::MsgPack.unpack(bytes).symbolize_keys
        Request.new(
          message[:id], 
          message[:method].to_sym, 
          message[:path], 
          (message[:body] || {}).symbolize_keys, 
          (message[:headers] || {}).symbolize_keys
        )
      end

      def response_from_bytes(bytes)
        message = FFI::MsgPack.unpack(bytes).symbolize_keys
        Response.new(
          message[:id], 
          message[:code], 
          (message[:body] || {}).symbolize_keys, 
          (message[:headers] || {}).symbolize_keys
        )
      end
    end
  end
end