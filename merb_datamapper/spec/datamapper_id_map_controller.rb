class IdMap < Application
  def index
    return 'false' unless Post.get(1)
    if (Post.get(1).object_id == Post.first(:id => 1).object_id)
      "true"
    else
      "false"
    end
  end
end
