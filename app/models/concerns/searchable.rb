module Searchable
  extend ActiveSupport::Concern

  included do
    after_save :sync_search_vector!, if: :searchable_fields_modified?
    has_one :search_vector, class_name: search_vector_class
  end

  module ClassMethods

    def search_vector_class
      "SearchVectors::#{to_s}".constantize
    end

    def searchable(on: [])
      define_singleton_method :searchable_fields, -> { Array(on) }
    end

    def rebuild_search_index!
      find_each(:batch_size => 100).map(&:sync_search_vector!)
    end
  end

  def sync_search_vector!
    self.class.search_vector_class.sync_searchable! self
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
