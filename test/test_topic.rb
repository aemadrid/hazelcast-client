require File.expand_path(File.dirname(__FILE__) + '/helper') unless defined?(HELPER_LOADED)

class TestHazelcastTopic < Test::Unit::TestCase

  def test_block_listener
    Notices.clear
    topic = CLIENT.topic :test_block
    topic.on_message do |msg|
      Notices << msg.to_s
    end
    assert_equal Notices.size, 0
    topic.publish "Hola!"
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "Hola!"
  end

  def test_class_listener
    Notices.clear
    topic = CLIENT.topic :test_class
    topic.add_message_listener TestMessageListener.new("test_class")
    assert_equal Notices.size, 0
    topic.publish "Hola!"
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "[test_class] Hola!"
  end

end
