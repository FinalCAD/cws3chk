module Cws3chk::Redis

  # TODO config
  def redis
    @redis ||= ::RedisProxy
  end
end
