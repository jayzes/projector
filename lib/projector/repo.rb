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
end