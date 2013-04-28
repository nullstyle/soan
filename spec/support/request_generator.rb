module RequestGenerator
  extend ActiveSupport::Concern

  def request(method, path, body={}, headers={})
    id = "1"
    request = Soan::Request.new(id, method, path, body, headers)
    (route, matches) = *router.recognize(request)
    RequestBundle.new(request, route, matches)
  end

  def get(*args)    ; request("get", *args) ; end
  def post(*args)   ; request("post", *args) ; end
  def put(*args)    ; request("put", *args) ; end
  def patch(*args)  ; request("patch", *args) ; end
  def delete(*args) ; request("delete", *args) ; end
    

  class RequestBundle < Struct.new(:request, :route, :matches) ; end

end

RSpec.configure do |config|
  config.include RequestGenerator
end