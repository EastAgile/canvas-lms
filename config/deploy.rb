require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :user, 'ec2-user'
set :application_name, 'canvas-lms'
set :domain, 'canvas.involvio.com'
set :deploy_to, '/home/ec2-user/ea-canvas-lms'
set :repository, 'git@github.com:EastAgile/canvas-lms.git'
set :branch, 'stable'
set :identity_file, 'deploy.pem'
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'public/dist', 'tmp/pids', 'tmp/sockets')
set :shared_files, fetch(:shared_files, []).push(
  'config/amazon_s3.yml',
  'config/delayed_jobs.yml',
  'config/database.yml',
  'config/domain.yml',
  'config/external_migration.yml',
  'config/file_store.yml',
  'config/outgoing_mail.yml',
  'config/security.yml',
)

task :environment do
  invoke :'rvm:use', 'ruby-2.4.0@ea-canvas-lms'
end

task :setup do
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:phased_restart'
    end
  end
end
