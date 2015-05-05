require 'spec_helper'
require 'active_model'

describe 'has_one' do
  let(:post) { Post.new(name: 'a', body: 'b', author: author) }
  let(:author) { Author.new(name: 'd') }
  let(:category) { Category.new(name: 'e') }
  let(:post_serializer) { PostSerializer.new(post) }
  let(:author_serializer) { AuthorSerializer.new(author) }

  class Post
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :body, :author, :category
  end

  class Author
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :category
  end

  class Category
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name
  end

  class PostSerializer < ActiveModel::CsvSerializer
    attributes :name, :body
    has_one :author
    has_one :category
  end

  class AuthorSerializer < ActiveModel::CsvSerializer
    attributes :name

    has_one :category
  end

  class CategorySerializer < ActiveModel::CsvSerializer
    attributes :name
  end

  it 'appends the associated objects csv data to this' do
    csv = post_serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
    expect(csv).to include(author.name)
  end

  it 'appends all associated objects csv data to this' do
    post.category = category
    csv = post_serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
    expect(csv).to include(author.name)
    expect(csv).to include(category.name)
  end

  it 'appends associated objects associations' do
    author.category = category
    csv = post_serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
    expect(csv).to include(author.name)
    expect(csv).to include(category.name)
  end

  it 'returns this csv data if no associated object' do
    author = nil
    csv = post_serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end
end
