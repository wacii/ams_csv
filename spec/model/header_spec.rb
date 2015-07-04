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
end
