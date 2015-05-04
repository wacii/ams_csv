require 'csv'

module ActiveModel
  class CsvSerializer
    class << self
      attr_reader :_attributes
    end

    def self.attributes(*attributes)
      @_attributes = attributes
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_csv
      self.class._attributes.collect do |attribute|
        next send(attribute) if respond_to?(attribute)
        @object.read_attribute_for_serialization(attribute)
      end.to_csv
    end
  end
end
