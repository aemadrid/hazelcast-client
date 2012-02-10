require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'yaml'

class TestRubyHazeQueue < Test::Unit::TestCase

  def test_single_queing
    tasks = CLIENT.queue :test_single
    qty = 50
    qty.times { |idx| tasks.put idx }
    found = []
    while !tasks.empty? do
      task = tasks.poll
      found << YAML::load(task)
    end
    assert !found.empty?
    assert_equal found.size, qty
  end

end
