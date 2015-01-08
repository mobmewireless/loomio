class SearchVectors::Comment < SearchVectors::Base
  self.table_name = :comment_search_vectors
  belongs_to :comment
  def self.resource_class
    :comment
  end
end
