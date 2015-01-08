class SearchVectors::Base < ActiveRecord::Base
  self.abstract_class = true

  def self.search_for(query, limit: 10)
    connection.execute(sanitize_sql_array [
      "SELECT #{resource_class}_id
       FROM   #{table_name}
       WHERE  search_vector @@ to_tsquery(:query)
       LIMIT  :limit", query: query, limit: limit
    ]).to_a.map(&:values).flatten
  end

  def self.sync_searchable!(searchable)
    connection.execute sanitize_sql_array [
      search_vector_sync_query(searchable),
      id:            searchable.id,
      search_data:   searchable.search_data,
      search_method: searchable.search_method
    ]
  end

  def self.search_vector_sync_query(searchable)
    if searchable.reload.search_vector.blank?
      "INSERT INTO
        #{table_name}
      (#{resource_class}_id, search_data, search_vector)
      VALUES (
        :id,
        :search_data,
        to_tsvector(:search_method, :search_data)
      )"
    else
      "UPDATE
         #{table_name}
       SET
         search_vector = to_tsvector(:search_method, :search_data),
         search_data = :search_data
       WHERE
         #{resource_class}_id = :id"
    end
  end

end
