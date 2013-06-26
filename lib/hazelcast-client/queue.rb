require 'yaml'

class Java::ComHazelcastClientProxy::ClientQueueProxy

  alias_method :unlearned_poll, :poll

  def poll(timeout = 5, unit = :seconds)
    unit = java.util.concurrent.TimeUnit.const_get(unit.to_s.upcase) if unit.is_a? Symbol
    unlearned_poll timeout, unit
  end
  
end
