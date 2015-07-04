require 'spec_helper'

describe 'has_many' do
  let(:post) { Post.new(name: 'a', body: 'b', comments: comments) }
  let(:comments) do
    [
      Comment.new(text: 'c'),
      Comment.new(text: 'd'),
      Comment.new(text: 'e')
    ]
  end
  let(:serializer) { PostCsvSerializer.new(post) }

  it 'appends associated objects csv to multiple copies of this' do
    csv = serializer.to_csv
    records = csv.split("\n")
    expect(records.length).to eq(comments.length + 1) # +1 for headers
    records.each.with_index do |record, i|
      next if i == 0
      expect(record).to include(post.name)
      expect(record).to include(post.body)

      comment = comments[i - 1] # -1 for headers
      expect(record).to include(comment.text)
    end
  end
end
