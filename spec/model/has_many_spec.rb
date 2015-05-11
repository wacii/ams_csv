require 'spec_helper'
require 'active_model'

describe 'has_many' do
  let(:post) { Post.new(name: 'a', body: 'b', comments: comments) }
  let(:comments) do
    [
      Comment.new(text: 'c'),
      Comment.new(text: 'd'),
      Comment.new(text: 'e')
    ]
  end
  let(:serializer) { PostSerializer.new(post) }

  class Post
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :body, :comments
  end

  class Comment
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :text
  end

  class PostSerializer < ActiveModel::CsvSerializer
    attributes :name, :body
    has_many :comments
  end

  class CommentCsvSerializer < ActiveModel::CsvSerializer
    attributes :text
  end

  it 'appends associated objects csv to multiple copies of this' do
    csv = serializer.to_csv
    records = csv.split("\n")
    expect(records.length).to eq(comments.length)
    records.each.with_index do |record, i|
      expect(record).to include(post.name)
      expect(record).to include(post.body)

      comment = comments[i]
      expect(record).to include(comment.text)
    end
  end
end
