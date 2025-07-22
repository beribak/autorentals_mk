namespace :javascript do
  desc "Install JavaScript dependencies"
  task :install do
    sh "yarn install --frozen-lockfile"
  end

  desc "Build JavaScript bundles with dependencies"
  task :build_with_install do
    Rake::Task["javascript:install"].invoke
    sh "yarn build"
  end
end

# Override the default javascript:build task from jsbundling-rails
if Rake::Task.task_defined?("javascript:build")
  Rake::Task["javascript:build"].clear
  task "javascript:build" => "javascript:build_with_install"
end
