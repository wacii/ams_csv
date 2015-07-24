require 'spec_helper'

describe 'attributes' do
  it 'pulls attributes off associated model' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = PostCsvSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end

  it 'favors methods defined on serializer' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = Post2CsvSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include('pie')
    expect(csv).to_not include(post.name)
    expect(csv).to include(post.body)
  end

  it 'allows attributes declaration to be split up' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = Post3CsvSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include(post.name)
    expect(csv).to include(post.body)
  end
end
