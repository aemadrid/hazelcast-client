class Java::ComHazelcastClientProxy::ClientTopicProxy

  java_import 'com.hazelcast.core.MessageListener'

  def on_message(&blk)
    klass = Class.new
    klass.send :include, MessageListener
    klass.send :define_method, :onMessage, &blk
    add_message_listener klass.new
  end

end

class Java::ComHazelcastCore::Message

  alias_method :original_to_s, :to_s

  alias_method :message, :get_message_object

  alias_method :to_s, :get_message_object

end
