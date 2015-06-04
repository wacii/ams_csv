require 'csv'
require 'active_support/inflections'

module ActiveModel
  class CsvArraySerializer
    def initialize(objects, options = {})
      @each_serializer = options[:each_serializer]
      @objects = objects
    end

    def to_a
      return ActiveModel::CsvSerializer.new(nil).to_a if @objects.nil?
      @objects.collect do |object|
        serializer = @each_serializer || ActiveModel::CsvSerializerFactory
        serializer.new(object).to_a
      end
    end

    def to_csv
      to_a.to_csv
    end
  end
end
