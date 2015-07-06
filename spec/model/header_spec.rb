require 'spec_helper'

describe 'headers' do
  it 'includes headers based on attribute names by default' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = PostCsvSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include('name')
    expect(csv).to include('body')
  end

  context 'when root option set to false during serializer instantiation' do
    it 'does not include headers' do
      post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
      serializer = PostCsvSerializer.new(post, root: false)
      csv = serializer.to_csv

      expect(csv).to_not include('name')
      expect(csv).to_not include('body')
    end
  end

  context 'when root set to false during class definition' do
    it 'does not include headers' do
      post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
      PostCsvSerializer.root = false
      serializer = PostCsvSerializer.new(post, root: false)
      csv = serializer.to_csv

      expect(csv).to_not include('name')
      expect(csv).to_not include('body')
    end
  end

  context 'when parent serializer root set to false' do
    it 'does not include headers' do
      post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
      ActiveModel::CsvSerializer.root = false
      serializer = PostCsvSerializer.new(post, root: false)
      csv = serializer.to_csv

      expect(csv).to_not include('name')
      expect(csv).to_not include('body')
    end
  end

  context 'when serialized object has one associated object' do
    it 'renders associated attributes prepended with its name' do
      category = Category.new(name: 'a')
      author = Author.new(name: 'b', category: category)
      serializer = AuthorCsvSerializer.new(author)
      csv = serializer.to_csv

      expect(csv).to include('name')
      expect(csv).to include('category_name')
    end
  end
end
