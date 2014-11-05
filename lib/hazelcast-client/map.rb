class Java::ComHazelcastCore::EntryEvent

  alias_method :name, :getName
  alias_method :source, :getSource
  alias_method :member, :getMember

  def type
    getEventType.name
  end

  alias_method :key, :getKey
  alias_method :old_value, :getOldValue
  alias_method :new_value, :getValue
  alias_method :value, :getValue

end

class Hazelcast::Client::DefaultMapListener

  include com.hazelcast.core.EntryListener

  def entryAdded(event)
    #puts "#{event.type} : #{event.key} : #{event.value}"
  end

  def entryRemoved(event)
    #puts "#{event.type} : #{event.key} : #{event.value}"
  end

  def entryUpdated(event)
    #puts "#{event.type} : #{event.key} : #{event.value}"
  end

  def entryEvicted(event)
    #puts "#{event.type} : #{event.key} : #{event.value}"
  end

  def method_missing(name, *params)
    #puts "method_missing : #{name} : #{params.inspect}"
  end

end

class Java::ComHazelcastClientProxy::ClientMapProxy

  java_import 'com.hazelcast.query.SqlPredicate'
  java_import 'com.hazelcast.core.EntryListener'

  def [](key)
    get key.to_s
  end

  def []=(key, value)
    put key.to_s, value
  end

  def keys(predicate = nil)
    predicate = prepare_predicate(predicate) unless predicate.is_a?(SqlPredicate)
    key_set(predicate).map
  end

  alias_method :unlearned_values, :values

  def values(predicate = nil)
    predicate = prepare_predicate(predicate) unless predicate.is_a?(SqlPredicate)
    unlearned_values(predicate).map
  end

  alias_method :find, :values

  def prepare_predicate(predicate)
    return if predicate.nil?
    case predicate
      when String
        SqlPredicate.new predicate
      when Hash
        query = predicate.map do |field, value|
          cmp = '='
          if value.is_a?(String)
            value = "'" + value + "'"
            cmp = 'LIKE' if value.index('%')
          end
          "#{field} #{cmp} #{value}"
        end.join(' AND ')
        SqlPredicate.new query
      else
        raise 'Unknown predicate type'
    end
  end

  java_import 'com.hazelcast.core.EntryListener'

  # ===================================================================
  # DEPRECATION NOTICE
  # -------------------------------------------------------------------
  # Deprecating this functionality in favor of actual listener classes

  def on_entry_added(key = nil, include_value = true, &blk)
    warn '[DEPRECATED] Use an actual class instead of a block'.red
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entryAdded, &blk
    klass.send :define_method, :method_missing do |name, *params|
      #puts "method_missing : (#{name.class.name}) #{name} : #{params.inspect}"
      true
    end
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_removed(key = nil, include_value = true, &blk)
    warn '[DEPRECATED] Use an actual class instead of a block'.red
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entryRemoved, &blk
    klass.send :define_method, :method_missing do |name, *params|
      #puts "method_missing : (#{name.class.name}) #{name} : #{params.inspect}"
      true
    end
    key ? add_entry_listener(klass.new(), key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_updated(key = nil, include_value = true, &blk)
    warn '[DEPRECATED] Use an actual class instead of a block'.red
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entryUpdated, &blk
    klass.send :define_method, :method_missing do |name, *params|
      #puts "method_missing : (#{name.class.name}) #{name} : #{params.inspect}"
      true
    end
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_evicted(key = nil, include_value = true, &blk)
    warn '[DEPRECATED] Use an actual class instead of a block'.red
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entryEvicted, &blk
    klass.send :define_method, :method_missing do |name, *params|
      #puts "method_missing : (#{name.class.name}) #{name} : #{params.inspect}"
      true
    end
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

end


