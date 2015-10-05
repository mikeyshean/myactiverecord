require_relative 'associatable'


module Associatable
  
  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) {

      source_options =
        through_options.model_class.assoc_options[source_name]

      result = DBConnection.execute(<<-SQL)
        SELECT
          source.*
        FROM
          #{source_options.table_name} AS source
        INNER JOIN
          #{through_options.table_name} AS through ON through.#{source_options.foreign_key} = source.#{source_options.primary_key}
        WHERE
          through.#{through_options.primary_key} = #{self.send(through_options.foreign_key)}
      SQL

      source_options.model_class.new(result.first)
      }

  end
end
