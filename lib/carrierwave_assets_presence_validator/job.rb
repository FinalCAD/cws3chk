# This job takes an ActiveRecord model, a column and a bunch of ids, and runs
# the check on all the versions of those objects. Including the original version.
class CarrierwaveAssetsPresenceValidator::Job
  # TODO config
  @queue = :z_low

  def self.perform klass_name, ids_json, threads, mounted_column
    ids = JSON.load ids_json
    request = klass_name.constantize.where id: ids
    CarrierwaveAssetsPresenceValidator::Validator.new(
      request, mounted_column, threads).check
  end
end
