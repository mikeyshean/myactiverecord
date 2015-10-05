require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |column| "#{column} = ?"}.join(" AND ")

    result = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        (#{where_line})
    SQL

    result.map { |params| self.new(params) }
  end
end

class SQLObject
  extend Searchable
end
