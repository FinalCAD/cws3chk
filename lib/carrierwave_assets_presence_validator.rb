require 'carrierwave_assets_presence_validator/version'
require 'threadify_procs'
require 'retryable_block'

module CarrierwaveAssetsPresenceValidator
  class ValidatorJob
    @queue = :z_low

    def self.perform klass_name, ids_json, threads, mounted_column
      ids = JSON.load ids_json
      request = klass_name.constantize.where id: ids
      Checker.new(request, mounted_column, threads).check
    end

    class Checker < Struct.new(:request, :mounted_column, :threads)
      include ThreadifyProcs
      include RetryableBlock

      def check
        call_with_threads procs, number_of_threads: threads
      end

      private

      # TODO refactor
      def procs
        [].tap do |_procs|
          request.each do |resource|
            next unless resource.public_send("#{mounted_column}?") # image?
            uploader = resource.public_send :mounted_column
            versions(uploader).each do |version|
              s3_path = path_for(uploader, version) # image.pdf.path
              _procs << Proc.new do
                s3_key = Aws::S3::Key.create bucket, s3_path
                begin
                  retryable{ s3_key.head }
                  print '.'
                rescue => e
                  puts e.message
                end
                headers = s3_key.headers
                size = headers['content-length'].to_i rescue 0
                if headers.blank? || size < 1.kilobyte
                  RedisProxy.sadd 'CarrierwaveAssetsPresenceValidator',
                    [resource.klass.name, resource.id, version].to_json
                end
              end
            end
          end
        end
      end

      def bucket
        if defined?(S3::Helper) == 'constant' && MyClassName.class == Class  
          @bucket ||= S3::Helper.current_bucket
        else
          #TODO with config
        end
      end

      def versions uploader
        [nil] + uploader.versions.keys
      end

      def path_for uploader, version=nil
        (version ? public_send(version) : self).path
      end
    end
  end
end
