raise "Rubyhaze only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
require 'java'
require 'rubygems'
require 'hazelcast-jars'

module Hazelcast
  class Client

    Hazelcast::Jars.all
    GEM_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(GEM_ROOT)

    java_import 'com.hazelcast.client.HazelcastClient'
#    java_import 'java.util.Map'

    attr_reader :username, :password, :host

    def initialize(username = nil, password = nil, host = nil)
      @username = username || "dev"
      @password = password || "dev-pass"
      @host     = host || "localhost"
      @client = self.class.connect @username, @password, @host
    end

    def cluster(name)
      @client.getCluster name.to_s
    end

    def list(name)
      @client.getList name.to_s
    end

    def lock(name)
      @client.getLock name.to_s
    end

    def map(name)
      @client.getMap name.to_s
    end

    def multi_map(name)
      @client.getMultiMap name.to_s
    end

    def queue(name)
      @client.getQueue name.to_s
    end

    def set(name)
      @client.getSet name.to_s
    end

    def topic(name)
      @client.getTopic name.to_s
    end

    def transaction
      txn = @client.getTransaction
      txn.begin
      begin
        yield
        txn.commit
        nil
      rescue => e
        txn.rollback
        e
      end
    end

    def respond_to?(meth)
      super || @client.respond_to?(meth)
    end

    def method_missing(meth, *args, &blk)
      if @client.respond_to? meth
        @client.send meth, *args, &blk
      else
        super
      end
    end

    def self.connections
      @connections ||= {}
    end

    def self.connect(username, password, host)
      conn_id = "#{username}:#{password}:#{host}"
      if connections.key? conn_id
        connections[conn_id]
      else
        puts ">> Connecting to [#{host}] as [#{username}] with [#{password}]..."
        connections[conn_id] ||= HazelcastClient.newHazelcastClient username, password, host
      end
    end

  end

end

%w{ map queue topic }.each do |name|
  require Hazelcast::Client::GEM_ROOT + '/hazelcast-client/' + name
end

at_exit do
  Hazelcast::Client.connections.each do |conn_id, client|
    puts ">> Shutting down #{client} before closing shop ..."
    client.shutdown
  end
end
