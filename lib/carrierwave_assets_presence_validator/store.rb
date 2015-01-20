require 'carrierwave_assets_presence_validator/redis'

class CarrierwaveAssetsPresenceValidator::Store < Struct.new(:resource, :mounted_column, :version)
  include CarrierwaveAssetsPresenceValidator::Redis

  # TODO redis or stdout > config
  def store_missing_asset
    redis.sadd 'CarrierwaveAssetsPresenceValidator::missing', base.to_json
  end
  
  def store_headers headers
    redis.sadd 'CarrierwaveAssetsPresenceValidator::metadata',
      (base + [headers]).to_json
  end
  
  private

  def base
    [resource.class.name,
     resource.id,
     mounted_column,
     version]
  end
end
