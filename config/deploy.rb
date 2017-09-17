require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :user, 'ec2-user'
set :application_name, 'canvas-lms'
set :domain, 'canvas.involvio.com'
set :deploy_to, '/home/ec2-user/ea-canvas-lms'
set :repository, 'git@github.com:EastAgile/canvas-lms.git'
set :branch, 'master'
set :identity_file, 'deploy.pem'
set :shared_paths, [
  'config/amazon_s3.yml',
  'config/delayed_jobs.yml',
  'config/domain.yml',
  'config/external_migration.yml',
  'config/file_store.yml',
  'config/outgoing_mail.yml',
  'config/security.yml',
]

task :environment do
  invoke :'rvm:use', 'ruby-2.4.0@ea-canvas-lms'
end

task :setup do
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end
end
