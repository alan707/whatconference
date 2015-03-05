desc "Reindex the models on Elasticsearch"
task :reindex do
  ENV['CLASS'] = 'Conference'
  Rake::Task['searchkick:reindex'].invoke
end

