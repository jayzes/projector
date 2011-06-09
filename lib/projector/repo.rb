Repo = Struct.new(:owner, :name) do
  def path
    "#{self.owner}/#{self.name}"
  end
  
  def clone_path(base_dir)
    File.join(base_dir, self.owner, self.name)
  end
  
  def clone_url
    "git@github.com:#{self.owner}/#{self.name}.git"
  end

  def clone(base_dir)
    system("git clone #{clone_url} #{clone_path(base_dir)}")
  end
  
  def local_head(base_dir)
    `cd #{clone_path(base_dir)} && git rev-parse master`.strip
  end
  
  def remote_head(base_dir)
    `cd #{clone_path(base_dir)} && git rev-parse origin/master`.strip
  end
  
  def fetch_refs(base_dir)
    system("cd #{clone_path(base_dir)} && git fetch origin")
  end
  
  def update(base_dir)
    system("cd #{clone_path(base_dir)} && git pull --rebase origin master")
  end
  
end