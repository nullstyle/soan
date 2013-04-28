require 'spec_helper'

describe Soan::Server::Router do

  let(:router) do
    Soan::Server::Router.new do
      get("/")                              { "root" }
      get("/users")                         { "users#index" }
      post("/users")                        { "users#create" }
      get("/users/:id")                     { "users#show" }
      patch("/users/:id")                   { "users#update" }
      get("/users/:user_id/messages")       { "users/messages#index" }
      post("/users/:user_id/messages")      { "users/messages#create" }
      get("/users/:user_id/messages/:id")   { "users/messages#show" }
      patch("/users/:user_id/messages/:id") { "users/messages#update" }
      get("/:something")                    { "catchall" }  
    end
  end

  subject{ router }

  describe "#recognize", "get root" do
    subject{ get "/" }
    it{ should route_to("root") }
    it{ should have_matches({}) }
  end

  describe "#recognize", "get static segment" do
    subject{ get "/users" }
    it{ should route_to("users#index") }
    it{ should have_matches({}) }
  end

  describe "#recognize", "post static segment" do
    subject{ post "/users" }
    it{ should route_to("users#create") }
    it{ should have_matches({}) }
  end

  describe "#recognize", "get with dynamic segment" do
    subject{ get "/users/123" }
    it{ should route_to("users#show") }
    it{ should have_matches({"id" => "123"}) }
  end

  describe "#recognize", "patch with dynamic segment" do
    subject{ patch "/users/123" }
    it{ should route_to("users#update") }
    it{ should have_matches({"id" => "123"}) }
  end

  describe "#recognize", "get with static segment after dynamic segment" do
    subject{ get "/users/123/messages" }
    it{ should route_to("users/messages#index") }
    it{ should have_matches({"user_id" => "123"}) }
  end

  describe "#recognize", "post with static segment after dynamic segment" do
    subject{ post "/users/123/messages" }
    it{ should route_to("users/messages#create") }
    it{ should have_matches({"user_id" => "123"}) }
  end

  describe "#recognize", "get with static/dynamic/static/dynamic" do
    subject{ get "/users/123/messages/456" }
    it{ should route_to("users/messages#show") }
    it{ should have_matches({"user_id" => "123", "id" => "456"}) }
  end

  describe "#recognize", "patch with static/dynamic/static/dynamic" do
    subject{ patch "/users/123/messages/456" }
    it{ should route_to("users/messages#update") }
    it{ should have_matches({"user_id" => "123", "id" => "456"}) }
  end
end