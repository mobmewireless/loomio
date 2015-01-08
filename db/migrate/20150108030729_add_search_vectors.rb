class AddSearchVectors < ActiveRecord::Migration
  def change
    create_table :discussion_search_vectors do |t|
      t.belongs_to  :discussion
      t.tsvector :search_vector
      t.text   :search_data
    end

    create_table :motion_search_vectors do |t|
      t.belongs_to  :motion
      t.tsvector :search_vector
      t.text   :search_data
    end

    create_table :comment_search_vectors do |t|
      t.belongs_to  :comment
      t.tsvector :search_vector
      t.text   :search_data
    end

    # execute("create index discussion_search_vector_index on discussion_search_vectors using gin(to_tsvector('simple', search_vector))")
    # execute("create index motion_search_vector_index on motion_search_vector_index using gin(to_tsvector('simple', search_vector))")
    # execute("create index comment_search_vector_index on comment_search_vector_index using gin(to_tsvector('simple', search_vector))")

  end
end
