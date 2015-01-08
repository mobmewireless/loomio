module Searchable
  extend ActiveSupport::Concern

  included do
    after_save :update_search_vector!, if: :searchable_fields_modified?

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
  end

  def update_search_vector!
    if search_vector.present?
      search_vector.update! search_vector: search_data, search_data: search_data
    else
      create_search_vector  search_vector: search_data, search_data: search_data
    end
  end

  private

  def searchable_fields_modified?
    (self.changed.map(&:to_sym) & self.class.searchable_fields).any?
  end

  def search_data
    self.class.searchable_fields.map { |field| send(field).to_s }.join " "
  end
end
