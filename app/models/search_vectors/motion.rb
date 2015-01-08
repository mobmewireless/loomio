class SearchVectors::Motion < ActiveRecord::Base
  belongs_to :motion
  self.table_name = :motion_search_vectors
  ts_vector :search_vector
end
