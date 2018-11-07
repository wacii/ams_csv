require 'csv'
require 'active_support/inflections'

module ActiveModel
  class CsvArraySerializer
    def initialize(objects, options = {})
      @each_serializer = options[:each_serializer]
      @root = options[:root].present? ? options[:root] : true
      @objects = objects
      @options = options
    end

    def to_a
      return ActiveModel::CsvSerializer.new(nil).to_a unless @objects
      @objects.collect do |object|
        serializer.new(object, @options).to_a.flatten
      end
    end

    def to_csv
      rows = to_a.collect(&:to_csv).join
      if @root
        attribute_names.to_csv << rows
      else
        rows
      end
    end

    def attribute_names
      return [] unless @objects
      serializer.new(@objects.first, @options).attribute_names
    end

    private
    def serializer
      @each_serializer || ActiveModel::CsvSerializerFactory
    end
  end
end
