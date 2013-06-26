require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'yaml'

class TestHazelcastLock < Test::Unit::TestCase

  def test_single_lock
    lock = CLIENT.lock :test_single_lock

    lock.unlock
    assert lock.unlocked?
    lock.lock
    assert lock.locked?
    lock.unlock
    assert lock.unlocked?

    lock.locking do
      assert lock.locked?
      sleep 0.1
      assert lock.locked?
    end
    assert lock.unlocked?
  end

  def test_double_lock
    lock_1 = CLIENT.lock :test_double_lock
    lock_2 = CLIENT.lock :test_double_lock

    lock_1.unlock
    assert lock_1.unlocked?
    assert lock_2.unlocked?

    lock_2.lock
    assert lock_1.locked?
    assert lock_2.locked?

    lock_1.unlock
    lock_1.locking do
      assert lock_1.locked?
      assert lock_2.locked?
      sleep 0.1
      assert lock_1.locked?
      assert lock_2.locked?
    end
    assert lock_1.unlocked?
    assert lock_2.unlocked?
  end

end
