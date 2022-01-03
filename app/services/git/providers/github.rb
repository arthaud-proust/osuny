class Git::Providers::Github

  def add_to_batch( path: nil,
                    previous_path: nil,
                    data:)
    @batch ||= []
    file = find_in_tree previous_path
    if file.nil? # New file
      @batch << {
        path: path,
        mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
        type: 'blob',
        content: data
      }
    elsif previous_path != path || file_sha(previous_path) != local_file_sha(data)
      # Different path or content
      @batch << {
        path: previous_path,
        mode: file[:mode],
        type: file[:type],
        sha: nil
      }
      @batch << {
        path: path,
        mode: file[:mode],
        type: file[:type],
        content: data
      }
    end
  end

  def commit_batch(commit_message)
    unless @batch.empty?
      new_tree = client.create_tree repository, @batch, base_tree: tree[:sha]
      commit = client.create_commit repository, commit_message, new_tree[:sha], branch_sha
      client.update_branch repository, default_branch, commit[:sha]
    end
    @tree = nil
    true
  end

  def remove(path, commit_message)
    client.delete_contents repository, path, commit_message, file_sha(path)
    true
  rescue
    false
  end

  def read_file_at(path)
    data = client.content repository, path: path
    Base64.decode64 data.content
  rescue
    ''
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def file_sha(path)
    begin
      content = client.content repository, path: path
      sha = content[:sha]
    rescue
      sha = nil
    end
    sha
  end

  def local_file_sha(data)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{data.bytesize}\x00#{data}"
  end

  def default_branch
    @default_branch ||= client.repo(repository)[:default_branch]
  end

  def branch_sha
    @branch_sha ||= client.branch(repository, default_branch)[:commit][:sha]
  end

  def tree
    @tree ||= client.tree repository, branch_sha, recursive: true
  end

  def find_in_tree(path)
    tree[:tree].each do |file|
      return file if path == file[:path]
    end
    nil
  end

  def tmp_directory
    "tmp/github/#{repository}"
  end
end