require 'active_support/inflections'

# TODO: Do you actually want a builder here? That doesn't act like serializer...
module ActiveModel
  module CsvSerializerBuilder
    def self.new(object)
      return ActiveModel::CsvSerializer.new(nil) if object.nil?
      klass = object.model_name.name + 'CsvSerializer'
      klass.constantize.new(object)
    end
  end
end
