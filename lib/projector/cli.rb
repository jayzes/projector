require 'thor'
require 'thor/actions'

module Projector

  class CLI < Thor

    # Includes
    include Thor::Actions
    include Projector::Helpers

    # Tasks
    desc "check", "Check Git settings to make sure Projector can work its magic properly"
    long_desc <<-DESC
      Projector will check to make sure that your Git settings contain your Github username 
      and API key (see http://help.github.com/set-your-user-name-email-and-github-token/) 
      as well as your preferred working directory
    DESC
    def check
      unless github_username?
        say 'You need to configure your github.user setting - "git config --global github.user <username>" should do the trick'
        exit 1
      end
      unless github_token?
        say 'You need to configure your github.token setting - "git config --global github.token <token>" should do the trick'
        exit 1
      end
      unless projector_working_dir?
        say 'You need to configure your projector.workingdir setting - "git config --global projector.workingdir <directory>" should do the trick'
        exit 1
      end      
    end
    
    
    desc "checkout", "Go through the Github repositories you can access and ensure that working copies for them are cloned into your working directory"
    long_desc <<-DESC
      Projector loops through all of the repositories that you can access and clones working
      copies of them under your configured working directory if they don't already exist
    DESC
    method_option :assume, :type => :boolean, :aliases => "-a"
    def checkout
      invoke :check
      repos = all_repos
      say "Checking #{repos.size} repositories"
      repos.each do |repo|
        say "Looking at #{repo.path}"
        if should_clone_repo?(repo, options[:assume])
          say "Cloning #{repo.clone_url} to #{repo.clone_path(projector_working_dir)}"
          repo.clone(projector_working_dir) 
        end
      end 
    end
    
    desc "update", "Go through the Github repositories you have in your working copy and see which ones need updating from origin"
    long_desc <<-DESC
      Projector loops through all of the repositories that you can access and updates the working
      copies of them under your configured working directory if they are outdated
    DESC
    method_option :assume, :type => :boolean, :aliases => "-a"
    def update
      invoke :check
      repos = all_repos
      say "Checking #{repos.size} repositories"
      repos.each do |repo|
        unless repo_cloned?(repo)
          say "Skipping #{repo.path} since it is not cloned"
          next
        end
        say "Looking at #{repo.path}"
        update_repo(repo) if repo_out_of_date?(repo) && (yes?("Repo #{repo.path} has remote changes.  Update it? (y/n)") || options[:assume])
      end 
    end
    
    
    
    

    desc "version", "Prints Projector's version information"
    def version
      say "Projector version #{Projector::VERSION}"
    end
    map %w(-v --version) => :version

  end

end
