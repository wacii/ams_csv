require 'csv'
require 'active_support/inflections'
require 'pry'

module ActiveModel
  class CsvSerializer
    class << self
      attr_accessor :_attributes, :_associations
    end

    def self.inherited(base)
      base._attributes = []
      base._associations = []
    end

    def self.attributes(*attributes)
      @_attributes = @_attributes.concat(attributes)
    end

    def self.has_one(associated)
      @_associations << {
        association: associated,
        serializer: ActiveModel::CsvSerializerBuilder
      }
    end

    def self.has_many(associated)
      @_associations << {
        association: associated,
        serializer: ActiveModel::CsvArraySerializer
      }
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_a
      return [[]] unless @object
      # serialize this object
      # TODO: always use array of records, even with one record
      values = []
      values << self.class._attributes.collect do |attribute|
        next send(attribute) if respond_to?(attribute)
        @object.read_attribute_for_serialization(attribute)
      end
      # associations
      self.class._associations.each do |hash|
        associated = associated(hash[:association])
        data = hash[:serializer].new(associated).to_a
        values = values.product(data).collect(&:flatten)
      end
      values
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
  end
end
