require 'threadify_procs'
require 'carrierwave_assets_presence_validator/s3'
require 'carrierwave_assets_presence_validator/store'

class CarrierwaveAssetsPresenceValidator::Validator < Struct.new(:request, :mounted_column, :threads)
  include ThreadifyProcs

  def check
    call_with_threads procs, number_of_threads: threads
  end

  private

  def procs
    [].tap do |_procs|
      iterate_over_resources_and_versions do |resource, uploader, version|
        _procs << Proc.new{ study resource, uploader, version }
      end
    end
  end

  def versions uploader
    [nil] + uploader.versions.keys
  end

  def iterate_over_resources_and_versions
    request.find_each do |resource|
      next unless resource.public_send("#{mounted_column}?") # resource.image?
      uploader = resource.public_send mounted_column # resource.image
      versions(uploader).each do |version|
        yield resource, uploader, version
      end
    end
  end

  def study resource, uploader, version
    s3 = CarrierwaveAssetsPresenceValidator::S3.new uploader, version
    store = CarrierwaveAssetsPresenceValidator::Store.new(
      resource, mounted_column, version)
    if s3.file_exists?
      store.store_headers s3.headers
    else
      store.store_missing_asset
    end
  end
end
