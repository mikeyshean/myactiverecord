require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions

  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name.to_s.singularize}_id".to_sym
    @class_name = options[:class_name] || "#{name.to_s.camelcase}"
    @primary_key = options[:primary_key] || "id".to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.singularize.underscore}_id".to_sym
    @class_name = options[:class_name] ||  "#{name.to_s.singularize.camelcase}"
    @primary_key = options[:primary_key] || "id".to_sym
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) {
      options = self.class.assoc_options[name]
      options
        .model_class
        .where(options.primary_key => self.send(options.foreign_key)).first
    }

  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.table_name, options)

    define_method(name) {
      options.model_class.where(options.foreign_key => self.send(options.primary_key))
    }
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
