# 2X dynos support no more than 512 Processes or Threads
# An AWS connection needs its own thread.
desc <<-DESC
This task launchs Resque Jobs to study Carrierwave assets. The links to those
assets are comming from the database through ActiveRecord.

You need to provide the name of the ActiveRecord model, the mounted column, the
number of available workers and the number of threads per worker.

Default:
* number of workers = 100
* number of threads = 250

Remember:
* On Heroku a 2X dyno has a limit of 512 Processes or Threads.
* An AWS connection needs its own thread with the aws gem.
DESC
task :collect_missing_assets, :model, :mounted_column, :workers, :threads do
  raise('No Rails environment !') unless Rake::Task[:environment]
  Rake::Task[:environment].invoke
  klass = args.model.camelize.constantize
  ids = klass.where.not(args.mounted_column => nil).pluck(:id)
  workers = args.workers.present? ? args.workers.to_i : 100
  threads = args.threads.present? ? args.threads.to_i : 250
  ids.each_slice(workers) do |ids_group|
    Resque.enqueue CarrierwaveAssetsPresenceValidator::Job,
      klass.name, ids_group.to_json, threads, mounted_column
  end
end
