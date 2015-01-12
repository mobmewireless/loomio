class SearchVectors::Motion < SearchVectors::Base
  self.table_name = :motion_search_vectors
  belongs_to :motion

  def self.resource_class
    :motion
  end

  def self.searchable_fields
    [:name, :description]
  end

  def self.tsvector_algorithm
    "setweight(to_tsvector(:name),        'A') ||
     setweight(to_tsvector(:description), 'B')"
  end

  def self.ranking_algorithm
    "ts_rank_cd(search_vector, :query)"
  end
end
