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
      def_delegators :all, :size, :<<, :first, :last, :clear, :map
    end
  end

  # Listen on messages
  class TestListener
    def initialize(name)
      @name = name
    end
    def on_message(msg)
      Notices << "[#{@name}] #{msg}"
    end
  end

  # Loading the Employee Java class
  $CLASSPATH << File.expand_path(File.dirname(__FILE__)) + '/'
  java_import 'Employee'

  # Finished loading helpers
  HELPER_LOADED = true
end
