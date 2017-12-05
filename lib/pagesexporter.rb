require 'fileutils'
require 'sinatra'
require 'json'
require 'git'

set :pages_dir, './pages'

get '/*' do |path|
  redirect "/pages/#{path}/", 303
end

post '/' do
  if request.env.key?('HTTP_X_GITLAB_EVENT') &&
     request.env['HTTP_X_GITLAB_EVENT'] == 'Push Hook'
    logger.info 'hook activated for GitLab Push'
    begin
      content = JSON.parse(request.body.read)
      namespace = content['project']['namespace']
      name = content['project']['name']
      git_url = content['project']['http_url']
      logger.info "parsed project #{namespace}/#{name} from url #{git_url}"
      dest_dir = "#{settings.pages_dir}/#{namespace}/#{name}"
      if File.directory?(dest_dir) then
        logger.info "pages already exists"
        FileUtils.rm_rf(dest_dir)
      end
    rescue StandardError => ex
      logger.error ex
      halt 400, { 'X-Error' => ex.class, 'X-Error-Message' => ex.message }, ''
    end
    begin
      repo = Git.clone(
        git_url,
        dest_dir
      )
      repo.checkout('origin/gh-pages')
      Dir.chdir(repo.dir.to_s) { FileUtils.rm_r '.git' }
      logger.info 'workingcopy exported'
    rescue Git::GitExecuteError => gitex
      logger.error gitex.message
      halt  404,
            {
              'X-Error' => 'Could not export pages branch.',
              'X-Error-Message' => gitex.message
            },
            ''
    rescue StandardError => ex
      logger.error ex
      halt 503, { 'X-Error' => ex.class, 'X-Error-Message' => ex.message }, ''
    end
  end
  redirect "/#{namespace}/#{name}/", 303
end
