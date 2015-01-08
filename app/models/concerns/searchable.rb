module Searchable
  extend ActiveSupport::Concern

  included do
    after_save :sync_search_vector!, if: :searchable_fields_modified?

    has_one search_vector_name, class_name: search_vector_class
    alias :search_vector        :"#{search_vector_name}"
    alias :search_vector=       :"#{search_vector_name}="
    alias :create_search_vector :"build_#{search_vector_name}"
    alias :build_search_vector  :"create_#{search_vector_name}"
  end

  module ClassMethods
    def search_vector_name
      :"#{to_s.downcase}_search_vector"
    end

    def search_vector_class
      "SearchVectors::#{to_s}".constantize
    end

    def searchable(on: [])
      define_singleton_method :searchable_fields, -> { Array(on) }
    end

    def sync_search_vector!(searchable)
      connection.execute sanitize_sql_array [
        search_vector_sync_query(searchable),
        id:            searchable.id,
        search_data:   searchable.search_data,
        search_method: searchable.search_method
      ]
    end

    def search_vector_sync_query(searchable)
      if searchable.search_vector.blank?
        "INSERT INTO
          #{search_vector_class.table_name}
        (#{to_s.downcase}_id, search_data, search_vector)
        VALUES (
          :id,
          :search_data,
          to_tsvector(:search_method, :search_data)
        )"
      else
        "UPDATE
           #{search_vector_class.table_name}
         SET
           search_vector = to_tsvector(:search_method, :search_data),
           search_data = :search_data
         WHERE
           #{to_s.downcase}_id = :id"
      end
    end
  end

  def sync_search_vector!
    self.class.sync_search_vector! self.reload
  end

  def search_data
    self.class.searchable_fields.map { |field| send(field).to_s }.join " "
  end

  def search_method
    :simple
  end

  private

  def searchable_fields_modified?
    (self.changed.map(&:to_sym) & self.class.searchable_fields).any?
  end

end
