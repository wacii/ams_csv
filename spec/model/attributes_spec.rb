require 'spec_helper'
require 'active_model'

describe 'attributes' do
  class Post
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :body
  end

  class PostSerializer < ActiveModel::CsvSerializer
    attributes :name, :body
  end

  class Post2Serializer < PostSerializer
    attributes :name, :body

    def name
      'pie'
    end
  end

  class Post3Serializer < ActiveModel::CsvSerializer
    attributes :name
    attributes :body
  end

  it 'pulls attributes off associated model' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = PostSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end

  it 'favors methods defined on serializer' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = Post2Serializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include('pie')
    expect(csv).to_not include(post.name)
    expect(csv).to include(post.body)
  end

  it 'allows attributes declaration to be split up' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = Post3Serializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end
end
