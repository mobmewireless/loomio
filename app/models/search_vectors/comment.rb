class SearchVectors::Comment < SearchVectors::Base
  self.table_name = :comment_search_vectors
  belongs_to :comment

  def self.resource_class
    :comment
  end

  def self.searchable_fields
    [:body]
  end

  def self.tsvector_algorithm
    "setweight(to_tsvector(coalesce(:body,'')), 'A')"
  end

  def self.ranking_algorithm
    "ts_rank_cd(search_vector, :query)"
  end
end
