raise "hazelcast-client only runs on JRuby. Sorry!" unless (RUBY_PLATFORM =~ /java/)
require 'java'
require 'rubygems'
require 'hazelcast-jars'

module Hazelcast
  class Client

    Hazelcast::Jars.all
    GEM_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(GEM_ROOT)

    attr_reader :username, :password, :host

    def initialize(username = nil, password = nil, host = nil)
      @username = username || "dev"
      @password = password || "dev-pass"
      @host     = host || "localhost"
      @conn_id  = self.class.connection_id @username, @password, @host
      self.class.connect @username, @password, @host
      client
    end

    def client
      self.class.connections[@conn_id]
    end

    def cluster(name)
      client.getCluster name.to_s
    end

    def list(name)
      client.getList name.to_s
    end

    def lock(name)
      client.getLock name.to_s
    end

    def map(name)
      client.getMap name.to_s
    end

    def multi_map(name)
      client.getMultiMap name.to_s
    end

    def queue(name)
      client.getQueue name.to_s
    end

    def set(name)
      client.getSet name.to_s
    end

    def topic(name)
      client.getTopic name.to_s
    end

    def transaction
      txn = client.getTransaction
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
      super || client.respond_to?(meth)
    end

    def method_missing(meth, *args, &blk)
      if client.respond_to? meth
        client.send meth, *args, &blk
      else
        super
      end
    end

    def self.connections
      @connections ||= {}
    end

    def self.connection_id(username, password, *hosts)
      "#{username}:#{password}:#{hosts.map{ |x| x.to_s }.sort.join('|')}"
    end

    def self.connect(username, password, *hosts)
      conn_id = connection_id(username, password, *hosts)
      if connections.key? conn_id
        connections[conn_id]
      else
        puts ">> Connecting to [#{hosts.inspect}] as [#{username}] with [#{password}]..."
        client_config = Java::ComHazelcastClientConfig::ClientConfig.new
        group_config = Java::ComHazelcastConfig::GroupConfig.new username, password
        hosts.each {|host| client_config.add_address host }
        client_config.set_group_config group_config
        connections[conn_id] = com.hazelcast.client.HazelcastClient.newHazelcastClient client_config
      end
    end

  end

end

%w{ lock map queue topic }.each do |name|
  require Hazelcast::Client::GEM_ROOT + '/hazelcast-client/' + name
end

at_exit do
  Hazelcast::Client.connections.each do |conn_id, client|
    puts ">> Shutting down #{client} before closing shop ..."
    client.shutdown
  end
end
