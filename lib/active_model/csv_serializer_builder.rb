require 'active_support/inflections'

module ActiveModel
  module CsvSerializerBuilder
    def self.for(name)
      (name.to_s.singularize.titleize.classify + 'CsvSerializer').constantize
    end
    def self.new(name, object)
      klass = name.to_s.singularize.titleize.classify + 'CsvSerializer'
      klass.constantize.new(object)
    end
  end
end
