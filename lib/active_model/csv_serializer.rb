require 'csv'

module ActiveModel
  class CsvSerializer
    class << self
      attr_accessor :_attributes, :_associations, :root
    end

    def self.inherited(base)
      base._attributes = []
      base._associations = []
      base.root = true
    end

    def self.attributes(*attributes)
      @_attributes = @_attributes.concat(attributes)
    end

    def self.has_one(associated)
      @_associations << {
        association: associated,
        serializer: ActiveModel::CsvSerializerFactory
      }
    end

    def self.has_many(associated)
      @_associations << {
        association: associated,
        serializer: ActiveModel::CsvArraySerializer
      }
    end

    attr_reader :object

    def initialize(object, options = {})
      @object = object
      @root = options.fetch(:root, self.class.root)
    end

    def to_a
      return [[]] unless @object

      values = []
      values << self.class._attributes.collect { |name| read_attribute(name) }

      self.class._associations.each do |hash|
        associated = read_association(hash[:association])
        data = hash[:serializer].new(associated).to_a
        values = values.product(data).collect(&:flatten)
      end

      values
    end

    def to_csv
      CSV.generate do |csv|
        csv << attribute_names if @root
        to_a.each { |record| csv << record }
      end
    end

    def attribute_names(prefix = '')
      names = self.class._attributes.collect do |attribute|
        prefix + attribute.to_s
      end
      self.class._associations.each do |hash|
        associated = read_association(hash[:association])
        next if associated.nil?
        next if hash[:serializer].is_a? ActiveModel::CsvArraySerializer # TODO
        serializer = hash[:serializer].new(associated)
        names.concat serializer.attribute_names("#{hash[:association]}_")
      end
      names
    end

    private

    def read_attribute(name)
      return send(name) if respond_to?(name)
      object.read_attribute_for_serialization(name)
    end

    def read_association(name)
      respond_to?(name) ? send(name) : object.send(name)
    end
  end
end
