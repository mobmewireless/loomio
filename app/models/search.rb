Search = Struct.new(:user, :query, :limit) do
  def discussion_results
    @discussion_results ||= select_results(Discussion)
  end

  def motion_results
    @motion_results     ||= select_results(Motion)
  end

  def comment_results
    @comment_results    ||= select_results(Comment)
  end

  def results
    {
      discussions: discussion_results,
      motions:     motion_results,
      comments:    comment_results
    }
  end

  private

  def select_results(model)
    [].tap do |results|
      raw_results(model).each_with_index { |id, index| results << SearchResult.new(model.find(id), query, index) }
    end
  end

  def raw_results(model)
    model.search_for(query, limit: limit).to_a.map(&:values).flatten
  end

end