require 'spec_helper'
require 'active_model'

describe ActiveModel::CsvSerializerBuilder do
  let(:post) { Post.new(name: 'a', body: 'b') }
  let(:Builder) { ActiveModel::CsvSerializerBuilder }

  class Post
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :name, :body
  end

  class Photo
    include ActiveModel::Model
    include ActiveModel::Serialization
  end

  class PostCsvSerializer < ActiveModel::CsvSerializer
    attributes :name, :body
  end

  describe '#new' do
    it 'builds a serializer with type based on singular association' do
      serializer = ActiveModel::CsvSerializerBuilder.new(post)
      expect(serializer).to be_a(PostCsvSerializer)
    end

    it 'builds a serializer with type based on plural association' do
      serializer = ActiveModel::CsvSerializerBuilder.new(post)
      expect(serializer).to be_a(PostCsvSerializer)
    end

    it 'raises name error when expected serializer not found' do
      expect do
        ActiveModel::CsvSerializerBuilder.new(Photo.new)
      end.to raise_error(NameError)
    end
  end
end
