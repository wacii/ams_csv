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

  it 'pulls attributes off associated model' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = PostSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end
end
