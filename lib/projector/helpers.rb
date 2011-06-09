require "net/https"
require "uri"
require 'json'

module Projector
  module Helpers
    def github_username
      `git config --get github.user`.strip
    end
    
    def github_username?
      github_username && github_username.length > 0
    end
    
    def github_token
      `git config --get github.token`.strip
    end
    
    def github_token?
      github_token && github_token.length > 0
    end
    
    def projector_working_dir
      `git config --get projector.workingdir`.strip
    end
    
    def projector_working_dir?
      projector_working_dir && projector_working_dir.length > 0
    end
    
    def repo_cloned?(repo)
      File.directory?(File.join(repo.clone_path(projector_working_dir), '.git'))
    end
    
    def should_clone_repo?(repo, assume_yes = false)
      !repo_cloned?(repo) && (assume_yes || yes?("Repo #{repo.path} is not cloned yet.  Clone it? (y/n)"))
    end
    
    def user_repos
      repo_api_request("https://github.com/api/v2/json/repos/show/#{github_username}")
    end
    
    def organization_repos
      repo_api_request("https://github.com/api/v2/json/organizations/repositories?owned=1")
    end    
    
    def collaborator_repos
      repo_api_request("https://github.com/api/v2/json/repos/pushable")
    end
    
    def all_repos
      (user_repos + organization_repos + collaborator_repos).uniq
    end
    
    def repo_api_request(endpoint)
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO: http://www.rubyinside.com/how-to-cure-nethttps-risky-default-https-behavior-4010.html
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth("#{github_username}/token", github_token)
      response = http.request(request)
      JSON.parse(response.body)['repositories'].map { |repo| Repo.new(repo['owner'], repo['name']) }
    end
      
  end
end