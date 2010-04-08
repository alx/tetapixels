set :application, "pixels.tetalab.org"

set :deploy_to,   "/var/www/pixels"
set :user,        "alex"
set :keep_releases, 3


set :scm,               :git
set :local_repository,  "git@git.tetalab.org:ledpong.git"
set :repository,        "file:///home/git/repositories/ledpong.git"
set :scm_user,          "git"
set :branch,            "master"
set :deploy_via,        :remote_cache

role :web, "pixels.tetalab.org"
role :app, "pixels.tetalab.org"
role :db,  "pixels.tetalab.org"

#========================
#CUSTOM
#========================

namespace :deploy do
  task :symlink do
    run "ln -sf #{deploy_to}/shared/db/test.db #{current_path}/test.db"
  end
end


namespace :deploy do
  
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :stop, :roles => :app do
    # Do nothing.
  end
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
end
