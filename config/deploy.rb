# config valid only for current version of Capistrano
lock "3.4.1"

set :application, "stackoverflow_clone"
set :repo_url, "git@github.com:gnomePasaran/Stack-clone.git"

set :deploy_to, "/home/deploy/apps/#{fetch(:application)}"

set :linked_files, fetch(:linked_files, []).push("config/database.yml", ".env", "puma.rb")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system")

set :rbenv_ruby, "2.3.1"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails sidekiq sidekiqctl)

set :puma_init_active_record, true
set :nginx_config_name, "stackoverflow_clone"

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, "cache:clear"
      end
    end
  end
end
