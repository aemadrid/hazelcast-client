unless defined?(HELPER_LOADED)

  require File.expand_path(File.dirname(__FILE__) + '/../lib/hazelcast-client')
  require 'test/unit'
  require 'forwardable'
  require 'date'

  # Load the Hazelcast cluster
  CLIENT = Hazelcast::Client.new 'dev', 'dev-pass', 'localhost'

  # Grab notices
  class Notices
    class << self
      extend Forwardable
      def all
        @all ||= []
      end
      def_delegators :all, :size, :<<, :first, :last, :clear, :map, :[]
    end
  end

  # Listen on messages
  class TestMessageListener
    def initialize(name)
      @name = name
    end
    def on_message(msg)
      Notices << "[#{@name}] #{msg}"
    end
  end

  # Listen on events
  class TestEventListener
    def initialize(name)
      @name = name
    end
    def entryAdded(event)
      Notices << "[#{@name}] added : #{event.key} : #{event.value}"
    end
    def entryRemoved(event)
      Notices << "[#{@name}] removed : #{event.key} : #{event.value}"
    end
    def entryUpdated(event)
      Notices << "[#{@name}] updated : #{event.key} : #{event.value}"
    end
    def entryEvicted(event)
      Notices << "[#{@name}] evicted : #{event.key} : #{event.value}"
    end
    def method_missing(name, *params)
      Notices << "[#{@name}] method_missing : #{name} : #{params.inspect}"
    end
  end

  # Loading the Employee Java class
  $CLASSPATH << File.expand_path(File.dirname(__FILE__)) + '/'
  java_import 'Employee'

  # Finished loading helpers
  HELPER_LOADED = true
end
