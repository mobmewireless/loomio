class SearchVectors::Base < ActiveRecord::Base
  self.abstract_class = true

  def self.search_for(query, limit: 10)
    connection.execute(sanitize_sql_array [
      "SELECT   #{resource_class}_id
       FROM     #{table_name}
       WHERE    search_vector @@ to_tsquery(:query)
       ORDER BY #{ranking_algorithm}
       LIMIT    :limit", query: query, limit: limit
    ]).to_a.map(&:values).flatten
  end

  def self.sync_searchable!(searchable)
    connection.execute sanitize_sql_array [
      search_vector_sync_query(searchable),
      search_vector_sync_options(searchable)
    ]
  end

  def self.search_vector_sync_query(searchable)
    if searchable.reload.search_vector.blank?
      "INSERT INTO
        #{table_name} (#{resource_class}_id, search_vector)
      SELECT
        id, #{tsvector_algorithm}
      FROM
        #{resource_class.to_s.pluralize} as model
      WHERE
        model.id = :id"
    else
      "UPDATE
         #{table_name}
       SET
         search_vector = #{tsvector_algorithm}
       WHERE
         #{resource_class}_id = :id"
    end
  end

  def self.search_vector_sync_options(searchable)
    { id: searchable.id }.tap do |hash|
      searchable_fields.each { |field| hash[field] = searchable.send(field) }
    end
  end

  # force search vector class to define these
  # there's probably a cleaner OO way to do this
  def self.resource_class
    raise NotImplementedError.new
  end

  def self.searchable_fields
    raise NotImplementedError.new
  end

  def self.tsvector_algorithm
    raise NotImplementedError.new
  end

  def self.ranking_algorithm
    raise NotImplementedError.new
  end

end
