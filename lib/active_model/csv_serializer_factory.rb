require 'active_support/inflections'

module ActiveModel
  module CsvSerializerFactory
    def self.new(object)
      return ActiveModel::CsvSerializer.new(nil) if object.nil?
      klass = object.model_name.name + 'CsvSerializer'
      klass.constantize.new(object)
    end
  end
end
