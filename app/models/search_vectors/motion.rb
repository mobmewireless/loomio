class SearchVectors::Motion < SearchVectors::Base
  self.table_name = :motion_search_vectors
  belongs_to :motion
  def self.resource_class
    :motion
  end
end
