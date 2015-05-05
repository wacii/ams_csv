require 'csv'
require 'active_support/inflections'

module ActiveModel
  class CsvSerializer
    class << self
      attr_accessor :_attributes
      attr_accessor :_singular_associations
    end

    def self.inherited(base)
      base._attributes = []
      base._singular_associations = {}
    end

    def self.attributes(*attributes)
      @_attributes = @_attributes.concat(attributes)
    end

    def self.has_one(associated)
      serializer = associated.to_s.classify + 'Serializer'
      @_singular_associations[associated] = serializer
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_a
      values = self.class._attributes.collect do |attribute|
        next send(attribute) if respond_to?(attribute)
        @object.read_attribute_for_serialization(attribute)
      end
      self.class._singular_associations.reduce(values) do |array, (k, v)|
        array.concat(associated_csv(k, v))
      end
    end

    def to_csv
      to_a.to_csv
    end

    private

    def associated(name)
      respond_to?(name) ? send(name) : object.send(name)
    end

    def associated_csv(association_name, serializer_klass)
      return [] unless associated = associated(association_name)
      serializer_klass.constantize.new(associated).to_a
    end
  end
end
