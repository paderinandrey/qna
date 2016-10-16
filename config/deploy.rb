# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'qna'
set :repo_url, 'git@github.com:paderinandrey/qna.git'
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache','bundle', 'tmp/sockets', 'public/system', 'public/assets', 'public/uploads'

set :rvm_ruby_version, '2.3.0'
set :format, :pretty
set :rvm_type, :user

set :passenger_environment_variables, { :passenger_instance_registry_dir => '/opt/nginx/tmp' }
set :passenger_restart_with_sudo, false # default
set :passenger_restart_command, 'passenger-config restart-app'

set :keep_releases, 3

namespace :deploy do
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechnism here, for example:
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end
  
  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end
  
  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end
  
  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
