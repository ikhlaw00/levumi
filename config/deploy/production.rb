# -*- encoding : utf-8 -*-
set :stage, :production
set :branch, 'development'

server "129.217.235.9", roles: %w{web app db}, user: 'ikhlawi', :primary => true

set :web_user, 'www-data'

#set :use_sudo, false

#set :asset_env, "RAILS_RELATIVE_URL_ROOT=/levumi"

set :rails_env, :production

namespace :custom do

#   task :chown do
#     on roles(:app) do
#       execute "chown -R #{fetch(:deploy_user)}:#{fetch(:web_user)} #{fetch(:deploy_to)}"
#     end
#   end

#   task :symlink do
#     on roles(:app) do
#       execute :sudo, "ln -s #{fetch(:deploy_to)}/current/public /var/www/levumi"
#       execute :sudo, "chown -R #{fetch(:deploy_user)}:#{fetch(:web_user)} /var/www/levumi"
#     end
#   end

 end
#
# after "deploy:setup", "custom:chown"
# after "deploy:update", "custom:chown"
# after "deploy:symlink", "custom:symlink"

namespace :deploy do
  after :deploy, :'passenger:restart'
end