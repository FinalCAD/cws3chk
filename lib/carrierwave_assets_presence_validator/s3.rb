require 'retryable_block'

class CarrierwaveAssetsPresenceValidator::S3 < Struct.new(:uploader, :version)
  include RetryableBlock

  # TODO put 1.kilobyte in config
  def file_exists?
    headers.present? && headers['content-length'].to_i > 1.kilobyte
  end

  def headers
    @headers ||= s3_key_headers
  end

  private

  def s3_key_headers
    s3_key.tap do |key|
      begin
        retryable{ key.head }
        print '.'
      rescue => e
        Rails.logger.warn "CarrierwaveAssetsPresenceValidator::S3 #{e.message}"
      end
    end.headers # Headers is blank if the head request has failed.
  end

  def s3_key
    Aws::S3::Key.create bucket, s3_key_path
  end

  def bucket
    if defined?(S3::Helper) == 'constant' && S3::Helper.class == Class  
      @bucket ||= S3::Helper.current_bucket
    else
      #TODO config
    end
  end

  def s3_key_path
    @s3_key_path ||= (version ? uploader.public_send(version) : uploader).path
  end
end
