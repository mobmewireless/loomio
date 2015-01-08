class SearchVectors::Discussion < SearchVectors::Base
  self.table_name = :discussion_search_vectors
  belongs_to :discussion
  def self.resource_class
    :discussion
  end
end
