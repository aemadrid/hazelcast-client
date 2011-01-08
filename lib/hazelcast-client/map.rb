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

end


