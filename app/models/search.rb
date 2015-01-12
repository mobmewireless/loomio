Search = Struct.new(:user, :query, :limit) do

  # I imagine these will get more complicated / distinct as we discover more advanced search options
  def discussion_results
    @discussions ||= begin
      ids = SearchVectors::Discussion.search_for(query, limit: limit)
      wrap_search_results Queries::VisibleDiscussions.new(user: user).where(id: ids)
    end
  end

  def motion_results
    @motions ||= begin
      ids = SearchVectors::Motion.search_for(query, limit: limit)
      wrap_search_results Queries::VisibleMotions.new(user: user).where(id: ids)
    end
  end

  def comment_results
    @comments ||= begin
      ids = SearchVectors::Comment.search_for(query, limit: limit)
      wrap_search_results Queries::VisibleComments.new(user: user).where(id: ids)
    end
  end

  def results
    discussion_results + motion_results + comment_results
  end

  private

  def wrap_search_results(models)
    [].tap do |results|
      models.each_with_index { |model, index| results << SearchResult.new(model, query, index) }
    end
  end
end