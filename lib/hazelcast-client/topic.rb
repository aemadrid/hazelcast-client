class Java::ComHazelcastClient::TopicClientProxy

  java_import 'com.hazelcast.core.MessageListener'

  def on_message(&blk)
    klass = Class.new
    klass.send :include, MessageListener
    klass.send :define_method, :on_message, &blk
    add_message_listener klass.new
  end

end