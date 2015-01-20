module CarrierwaveAssetsPresenceValidator
  class Job
    # TODO config
    @queue = :z_low

    def self.perform klass_name, ids_json, threads, mounted_column
      ids = JSON.load ids_json
      request = klass_name.constantize.where id: ids
      Checker.new(request, mounted_column, threads).check
    end
  end
end
