require 'rails_helper'

shared_examples_for Searchable do

  let(:searchable) { build described_model_name, searchable_test_field => 'my test field' }

  before do
    described_class.searchable on: searchable_test_field
  end

  describe 'search_vector_name' do
    it 'returns the name of the search vector' do
      expect(described_class.search_vector_name).to eq :"#{described_model_name}_search_vector"
    end
  end

  describe 'searchable_fields' do
    it 'is created through the searchable on: method' do
      expect(described_class.searchable_fields).to include :title
    end
  end

  describe 'search_vector' do
    it 'is created when the searchable is created' do
      searchable.save!
      expect(searchable.search_vector).to be_present
      expect(searchable.search_vector.search_data).to match /my test field/
    end

    it 'is updated when the searchable fields are updated' do
      searchable.save!
      searchable.update! searchable_test_field => 'new field value'
      expect(searchable.search_vector).to be_present
      expect(searchable.search_vector.search_data).to match /new field value/
    end
  end

end

def searchable_test_field
  case described_model_name.to_sym
  when :discussion then :title
  when :motion     then :name
  when :comment    then :body
  end
end