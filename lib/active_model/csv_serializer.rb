require 'csv'

module ActiveModel
  class CsvSerializer
    class << self
      attr_accessor :_attributes, :associations, :root
    end

    def self.inherited(base)
      base._attributes = []
      base.associations = []
      base.root = true
    end

    def self.attributes(*attributes)
      @_attributes = @_attributes.concat(attributes)
    end

    def self.has_one(associated)
      @associations << {
        associated: associated,
        serializer: ActiveModel::CsvSerializerFactory
      }
    end

    def self.has_many(associated)
      @associations << {
        associated: associated,
        serializer: ActiveModel::CsvArraySerializer
      }
    end

    attr_reader :object

    def initialize(object, options = {})
      @object = object
      @root = options.fetch(:root, self.class.root)
      @prefix = options.fetch(:prefix, '')
    end

    def to_a
      return [[]] unless @object

      values = []
      values << self.class._attributes.collect { |name| read_attribute(name) }

      associated_serializers.each do |serializer|
        values = values.product(serializer.to_a).collect(&:flatten)
      end

      values
    end

    def to_csv
      CSV.generate do |csv|
        csv << attribute_names if @root
        to_a.each { |record| csv << record }
      end
    end

    def attribute_names
      # TODO: null object returned for associations not playing nicely here
      #   review use of inherited hook, likely why _attributes is nil
      return [] unless @object
      names = self.class._attributes.collect do |attribute|
        @prefix + attribute.to_s
      end
      associated_serializers.reduce(names) do |names, serializer|
        names.concat serializer.attribute_names
      end
    end

    private

    def read_attribute(name)
      return send(name) if respond_to?(name)
      object.read_attribute_for_serialization(name)
    end

    def read_association(name)
      respond_to?(name) ? send(name) : object.send(name)
    end

    def associated_serializers
      @associated_serializers ||= self.class.associations.collect do |hash|
        object = read_attribute(hash[:associated])
        hash[:serializer].new(object, prefix: hash[:associated].to_s + '_')
      end
    end
  end
end
