class Java::ComHazelcastClient::MapClientProxy

  java_import 'com.hazelcast.query.SqlPredicate'

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

  alias :find :values

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
        raise "Unknown predicate type"
    end
  end

  java_import 'com.hazelcast.core.EntryListener'

  def on_entry_added(key = nil, include_value = true, &blk)
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entry_added, &blk
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_removed(key = nil, include_value = true, &blk)
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entry_removed, &blk
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_updated(key = nil, include_value = true, &blk)
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entry_updated, &blk
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

  def on_entry_evicted(key = nil, include_value = true, &blk)
    klass = Class.new
    klass.send :include, EntryListener
    klass.send :define_method, :entry_evicted, &blk
    key ? add_entry_listener(klass.new, key, include_value) : add_entry_listener(klass.new, include_value)
  end

end


