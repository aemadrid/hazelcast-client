require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestRubyHazeHash < Test::Unit::TestCase

  java_import 'com.hazelcast.query.SqlPredicate'

  def test_same_object
    hash = CLIENT.map :test_same_object
    map  = CLIENT.map :test_same_object
    assert_equal hash.name, map.name
    hash[:a] = 1
    assert_equal hash[:a], map[:a]
  end

  def test_string_keys
    hash     = CLIENT.map :test_string_keys

    hash[:a] = 1
    assert_equal hash['a'], 1
    assert_equal hash[:a], 1

    hash['b'] = 2
    assert_equal hash[:b], 2

    hash[Date.new(2010, 3, 18)] = 3
    assert_equal hash['2010-03-18'], 3

    hash[4] = 4
    assert_equal hash['4'], 4
    assert_equal hash[4], 4
  end

  def test_predicates
    map       = CLIENT.map :test_predicates

    predicate = map.prepare_predicate "active = false AND (age = 45 OR name = 'Joe Mategna')"
    assert_kind_of SqlPredicate, predicate
    assert_equal "(active=false AND (age=45 OR name=Joe Mategna))", predicate.to_s

    predicate = map.prepare_predicate :quantity => 3
    assert_kind_of SqlPredicate, predicate
    assert_equal 'quantity=3', predicate.to_s

    predicate = map.prepare_predicate :country => "Unites States of America"
    assert_kind_of SqlPredicate, predicate
    assert_equal "country=Unites States of America", predicate.to_s
  end

  def test_entry_added
    Notices.clear
    map       = CLIENT.map :test_entry_added
    map.on_entry_added do |event|
      Notices << "added : #{event.key} : #{event.value}"
    end

    assert_equal Notices.size, 0
    k, v = "a1", "b2"
    map[k] = v
    sleep 0.5
    puts "Notices : #{Notices.all.inspect}"
    assert_equal Notices.size, 1
    assert_equal Notices.last, "added : #{k} : #{v}"
  end

  def test_entry_removed
    Notices.clear
    map       = CLIENT.map :test_entry_removed
    map.on_entry_removed do |event|
      Notices << "removed : #{event.key} : #{event.value}"
    end

    assert_equal Notices.size, 0
    k, v = "a1", "b2"
    map[k] = v
    map.remove k
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "removed : #{k} : #{v}"
  end

  def test_entry_updated
    Notices.clear
    map       = CLIENT.map :test_entry_updated
    map.on_entry_updated do |event|
      Notices << "updated : #{event.key} : #{event.value}"
    end

    assert_equal Notices.size, 0
    k, v = "a1", "b2"
    map[k] = "b1"
    map[k] = v
    sleep 0.5
    puts "Notices : #{Notices.all.inspect}"
    assert_equal Notices.size, 2
    assert_equal Notices.first, "updated : #{k} : b1"
    assert_equal Notices.last, "updated : #{k} : #{v}"
  end

  def test_entry_evicted
    Notices.clear
    map       = CLIENT.map :test_entry_evicted
    map.on_entry_evicted do |event|
      Notices << "evicted : #{event.key} : #{event.value}"
    end

    assert_equal Notices.size, 0
    k, v = "a1", "b2"
    map[k] = v
    map.evict k
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "evicted : #{k} : #{v}"
  end

end
