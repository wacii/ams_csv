require 'csv'
require 'active_support/inflections'

module ActiveModel
  class CsvSerializer
    class << self
      attr_accessor :_attributes
      attr_accessor :_singular_associations
      attr_accessor :_has_many_associations
    end

    def self.inherited(base)
      base._attributes = []
      base._singular_associations = {}
      base._has_many_associations = {}
    end

    def self.attributes(*attributes)
      @_attributes = @_attributes.concat(attributes)
    end

    def self.has_one(associated)
      serializer = associated.to_s.classify + 'Serializer'
      @_singular_associations[associated] = serializer
    end

    def self.has_many(associated)
      serializer = associated.to_s.singularize.classify + 'Serializer'
      @_has_many_associations[associated] = serializer
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_a
      # serialize this object
      # TODO: always use array of records, even with one record
      values = []
      values << self.class._attributes.collect do |attribute|
        next send(attribute) if respond_to?(attribute)
        @object.read_attribute_for_serialization(attribute)
      end
      # serialize objects associated through has one relations
      self.class._singular_associations.each do |k, v|
        values[0].concat(associated_csv(k, v))
      end
      # serialize objects associated through has many relationss
      has_many = self.class._has_many_associations.reduce([]) do |array, (k, v)|
        array.concat(associated_csv(k, v))
      end
      return values if has_many.empty?
      has_many.collect do |record|
        values[0] + record
      end
    end

    def to_csv
      CSV.generate do |csv|
        to_a.each { |record| csv << record }
      end
    end

    private

    # TODO: read_attribute vs read_association, extract into methods

    def associated(name)
      respond_to?(name) ? send(name) : object.send(name)
    end

    def associated_csv(association_name, serializer_klass)
      return [] unless associated = associated(association_name)
      if associated.is_a?(Array)
        # TODO: each_serializer option
        ActiveModel::CsvArraySerializer.new(associated).to_a
      else
        serializer_klass.constantize.new(associated).to_a
      end
    end
  end
end
