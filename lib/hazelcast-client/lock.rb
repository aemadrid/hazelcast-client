class Java::ComHazelcastClientProxy::ClientLockProxy

  # lock()
  # unlock()

  def unlocked?
    !locked?
  end

  def locking(options = {})
    raise 'Must provide a block' unless block_given?
    options = { :tries => 1, :timeout => 5, :unit => :seconds, :failed => false }.update options
    options[:unit] = java.util.concurrent.TimeUnit.const_get(options[:unit].to_s.upcase) if options[:unit].is_a? Symbol

    while options[:tries] > 0
      if try_lock(options[:timeout], options[:unit])
        options[:tries] = 0
        result          = yield
        unlock
        return result
      else
        options[:tries] -= 1
      end
    end
    options[:failed]
  end

end
