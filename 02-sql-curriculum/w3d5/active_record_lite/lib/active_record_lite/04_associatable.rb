require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    @name.singularize.camelize.constantize
  end

  def table_name
    model_class.table_name
  end

  def update_params(options = {})
    options.each do |k, v|
      self.instance_variable_set("@#{k}", v)
    end
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @class_name = @name.singularize.camelize
    @primary_key = :id
    @foreign_key = "#{@name}_id".to_sym
    update_params(options)
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @class_name = @name.singularize.camelize
    @primary_key = :id
    @foreign_key = "#{self_class_name.underscore}_id".to_sym
    update_params(options)
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
