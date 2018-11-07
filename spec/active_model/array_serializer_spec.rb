require 'spec_helper'

describe 'ArraySerializer' do
  let(:comments) { [comment_1, comment_2] }
  let(:comment_1) { Comment.new(text: 'a') }
  let(:comment_2) { Comment.new(text: 'b') }
  let(:post) { Post.new(name: 'c', body: 'd') }


  context 'with specified serializer' do
    subject {
      ActiveModel::CsvArraySerializer.new(
        comments,
        each_serializer: CommentCsvSerializer
      ).to_csv
    }

    it 'renders csv and includes headers.' do
      expect(subject).to include('text')
    end

    it 'renders csv with the correct number of rows.' do
      lines = subject.split("\n")
      expect(lines.size).to eq(3)
    end

    it 'renders csv with content.' do
      expect(subject).to include(comment_1.text)
      expect(subject).to include(comment_2.text)
    end
  end

  context 'without specified serializer' do
    subject { ActiveModel::CsvArraySerializer.new(comments).to_csv }

    it 'renders csv and includes headers.' do
      expect(subject).to include('text')
    end

    it 'renders csv with the correct number of rows.' do
      lines = subject.split("\n")
      expect(lines.size).to eq(3)
    end

    it 'renders csv with content.' do
      expect(subject).to include(comment_1.text)
      expect(subject).to include(comment_2.text)
    end
  end

  it 'raises an exception when expected serializer not found' do
    comments << Object.new
    array_serializer = ActiveModel::CsvArraySerializer.new(comments)

    expect{ array_serializer.to_csv }.to raise_error(NameError)
  end
end
