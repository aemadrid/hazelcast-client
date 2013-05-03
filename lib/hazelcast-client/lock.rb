class Java::ComHazelcastClient::LockClientProxy
  
  # lock()
  # unlock()

  def locking(options = {})
    raise 'Must provide a block' unless block_given?
    tries = options[:tries] || 1
    timeout = options[:timeout] || 5
    unit = options[:unit] || :seconds
    unit = java.util.concurrent.TimeUnit.const_get unit.to_s.upcase if unit.is_a? Symbol
    failed = options[:failed] || false
    result = nil
    while tries > 0
      if try_lock(timeout, unit)
        tries = 0
        result = yield
        unlock
        return result
      else
        tries -= 1
      end
    end
    failed
  end

end
