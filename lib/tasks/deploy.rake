# Deploy and rollback on Heroku
# Modified from https://gist.github.com/njvitto/362873 (Nicola Junior Vitto, 2010)
#
# To show this help, run rake deploy:help
#
# To deploy develop to staging, run rake deploy:staging 
# To deploy master to production, run rake deploy:production 
#
# To deploy a specific branch to staging, run rake deploy:staging branch=my_feature
#
# To run migrations after deploying, run rake deploy:staging_migrations
# or rake deploy:production_migrations
#
# If the deploy went wrong, try to go back to the previous version with
# rake deploy:staging_rollback or rake deploy:production_rollback

namespace :deploy do
  APP = 'whatconference'
  ORIGIN = 'origin'
  HEROKU_GIT = ENV['HEROKU_GIT'] || 'heroku.com'
  GIT_BRANCH = ENV['branch'] || 'master'

  desc "Deploy to Heroku"
  task :heroku => [:push, :restart]

  desc "Deploy to Heroku, performing migrations"
  task :migrations => [:push, :off, :migrate, :restart, :on]

  task :push do
    puts "==========================================="
    puts "Deploying #{GIT_BRANCH} to Heroku #{APP}..."
    puts "==========================================="
    puts `git push -f git@#{HEROKU_GIT}:#{APP}.git #{GIT_BRANCH}:master`
  end
  
  task :restart do
    puts "==========================================="
    puts 'Restarting app servers ...'
    puts "==========================================="
    Bundler.with_clean_env do
      puts `heroku restart --app #{APP}`
    end
  end
  
  task :migrate do
    puts "==========================================="
    puts 'Running database migrations ...'
    puts "==========================================="
    Bundler.with_clean_env do
      puts `heroku run rake db:migrate --app #{APP}`
    end
  end
  
  task :off do
    puts "==========================================="
    puts 'Putting the app into maintenance mode ...'
    puts "==========================================="
    Bundler.with_clean_env do
      puts `heroku maintenance:on --app #{APP}`
    end
  end
  
  task :on do
    puts "==========================================="
    puts 'Taking the app out of maintenance mode ...'
    puts "==========================================="
    Bundler.with_clean_env do
      puts `heroku maintenance:off --app #{APP}`
    end
  end
end

# Alias rake deploy to rake deploy:heroku
task :deploy => ["deploy:heroku"]
