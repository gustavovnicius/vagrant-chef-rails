set :ssh_options, {
  forward_agent: true,
  auth_methods: ['publickey']
}

set :pty, true
set :application, 'APPLICATION_NAME'
set :scm, :git
set :repo_url, 'GIT_URL'
set :deploy_to, 'SERVER_PROJECT_PATH'
set :user, 'ubuntu'

# cap environment deploy BRANCH=nome_da_branch
set :branch, ENV['BRANCH'] || 'master'

set :rbenv_custom_path, '/opt/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :use_sudo, false
set :keep_releases, 5

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system conlicitacao_autenticacao_consumidor/log}

after 'deploy', 'deploy:migrate'
after 'deploy', 'deploy:restart'


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :service, 'unicorn restart'
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
