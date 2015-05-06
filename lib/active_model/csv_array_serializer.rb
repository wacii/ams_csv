require 'csv'
require 'active_support/inflections'

module ActiveModel
  class CsvArraySerializer
    def initialize(objects, options = {})
      @each_serializer = options[:each_serializer]
      @objects = objects
    end

    def to_a
      @objects.collect do |object|
        serializer = @each_serializer || serializer_for(object)
        serializer.new(object).to_a
      end
    end

    def to_csv
      to_a.to_csv
    end

    private

    def serializer_for(object)
      # TODO: prepend Csv or not, extract this code out
      "#{object.class.name}CsvSerializer".constantize
    end
  end
end
