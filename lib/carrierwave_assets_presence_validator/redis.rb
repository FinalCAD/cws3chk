module CarrierwaveAssetsPresenceValidator::Redis

  # TODO config
  def redis
    @redis ||= ::RedisProxy
  end
end
