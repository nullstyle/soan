require 'soan'
$server = Soan::Server.make("test", "tcp://127.0.0.1/") do
  get "/" do
    {:message => "word"}
  end

  get "/users/:id" do # |id:nil, **params| ? kwargs, perhaps?
    {
      :user => {
        :id => params[:id],
        :name => "Some user"
      }
    }
  end

  post "/users" do
    {:message => "created a user: #{params.inspect}"}
  end
end


$server.bind
$server.async.run
