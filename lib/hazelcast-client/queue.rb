require 'yaml'

class Java::ComHazelcastClient::QueueClientProxy

  alias_method :unlearned_poll, :poll

  def poll(timeout = 5, unit = :seconds)
    unlearned_poll timeout, java.util.concurrent.TimeUnit.const_get(unit.to_s.upcase)
  end
  
end