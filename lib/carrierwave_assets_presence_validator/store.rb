require 'carrierwave_assets_presence_validator/redis'

class CarrierwaveAssetsPresenceValidator::Store < Struct.new(:resource, :mounted_column, :version)
  include CarrierwaveAssetsPresenceValidator::Redis

  # TODO redis or stdout > config
  def store_missing_asset
    redis.sadd 'CarrierwaveAssetsPresenceValidator::missing', base.to_json
  end
  
  def store_headers headers
    redis.sadd 'CarrierwaveAssetsPresenceValidator::metadata',
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

 RedisProxy
 CarrierwaveAssetsPresenceValidator::Validator.new(Project.find(417).comments.with_image.limit(2), :image, 10).check
 pp JSON.load RedisProxy.smembers("CarrierwaveAssetsPresenceValidator::metadata").first ; nil
