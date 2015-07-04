require 'spec_helper'

describe 'headers' do
  it 'includes headers based on attribute names by default' do
    post = Post.new(name: 'Samwise', body: 'Hobbit extraordinaire.')
    serializer = PostCsvSerializer.new(post)
    csv = serializer.to_csv

    expect(csv).to include('name')
    expect(csv).to include('body')
  end
end
