environment 'production'
workers 2
threads 1, 2
daemonize true

app_dir = "/home/ec2-user/ea-canvas-lms"
shared_dir = "#{app_dir}/shared"

bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
directory "#{app_dir}/current"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"
prune_bundler
