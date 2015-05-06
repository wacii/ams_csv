require 'spec_helper'
require 'active_model'

describe 'ArraySerializer' do
  let(:comments) { [comment_1, comment_2] }
  let(:comment_1) { Comment.new(text: 'a') }
  let(:comment_2) { Comment.new(text: 'b') }
  let(:post) { Post.new(name: 'c', body: 'd') }

  class Post
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :body
  end

  class Comment
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :text
  end

  class CommentCsvSerializer < ActiveModel::CsvSerializer
    attributes :text
  end

  it 'renders csv using specified serializer' do
    array_serializer = ActiveModel::CsvArraySerializer.new(
      comments,
      each_serializer: CommentCsvSerializer
    )
    csv = array_serializer.to_csv

    expect(csv).to include(comment_1.text)
    expect(csv).to include(comment_2.text)
  end

  it 'renders csv without specified serializer' do
    array_serializer = ActiveModel::CsvArraySerializer.new(comments)
    csv = array_serializer.to_csv

    expect(csv).to include(comment_1.text)
    expect(csv).to include(comment_2.text)
  end

  it 'raises an exception when expected serializer not found' do
    comments << post
    array_serializer = ActiveModel::CsvArraySerializer.new(comments)

    expect{ array_serializer.to_csv }.to raise_error(NameError)
  end
end
