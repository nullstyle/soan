Celluloid::ActorProxy.class_eval do 
  def inspect
    "#<Celluloid::ActorProxy(#{@klass})>"
  end
end