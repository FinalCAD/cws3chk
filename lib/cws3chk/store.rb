require 'cws3chk/redis'

class Cws3chk::Store < Struct.new(:resource, :mounted_column, :version)
  include Cws3chk::Redis

  # TODO redis or stdout > config
  def store_missing_asset
    redis.sadd 'Cws3chk::missing', base.to_json
  end
  
  def store_headers headers
    redis.sadd 'Cws3chk::metadata',
      (base + [headers['content-length']]).to_json
  end
  
  private

  def base
    [resource.class.name,
     resource.id,
     mounted_column,
     version]
  end
end
