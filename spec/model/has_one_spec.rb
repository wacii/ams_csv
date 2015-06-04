require 'spec_helper'

describe 'has_one' do
  let(:post) { Post.new(name: 'a', body: 'b', author: author) }
  let(:author) { Author.new(name: 'd') }
  let(:category) { Category.new(name: 'e') }
  let(:post_serializer) { PostCsvSerializer.new(post) }
  let(:author_serializer) { AuthorCsvSerializer.new(author) }

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
