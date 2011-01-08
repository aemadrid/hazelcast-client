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

end
