# 2X dynos support no more than 512 Processes or Threads
# An AWS connection needs its own thread.
task :collect_missing_assets, :model, :mounted_column, :workers, :threads do
  raise('No Rails environment !') unless Rake::Task[:environment]
  Rake::Task[:environment].invoke
  klass = args.model.camelize.constantize
  ids = klass.where.not(args.mounted_column => nil).pluck(:id)
  workers = args.workers.present? ? args.workers.to_i : 100
  threads = args.threads.present? ? args.threads.to_i : 250
  ids.each_slice(workers) do |ids_group|
    Resque.enqueue CarrierwaveAssetsPresenceValidator,
      klass.name, ids_group.to_json, threads, mounted_column
  end
end
