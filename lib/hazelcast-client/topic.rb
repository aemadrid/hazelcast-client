class Java::ComHazelcastClientProxy::ClientTopicProxy

  java_import 'com.hazelcast.core.MessageListener'
  
  class MessageDispatch
    include MessageListener
      
    def initialize(callback)
      @callback = callback
    end
    
    def onMessage(*args)
      @callback.call(*args)
    end
  end

  def on_message(callback = nil, &blk)
    add_message_listener MessageDispatch.new(callback || blk)
  end

end

class Java::ComHazelcastCore::Message

  alias_method :original_to_s, :to_s

  alias_method :message, :get_message_object

  alias_method :to_s, :get_message_object

end
