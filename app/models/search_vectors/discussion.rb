class SearchVectors::Discussion < ActiveRecord::Base
  belongs_to :discussion
  self.table_name = :discussion_search_vectors
  ts_vector :search_vector
end
