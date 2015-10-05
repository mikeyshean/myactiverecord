# ActiveRecordLite

*ActiveRecordLite* is an ORM inspired by the many helpful conventions provided by Rails' ActiveRecord.


[heroku]: http://trackstack.audio

## Features
- `SQLObject` class provides object oriented interaction with the database
- `Searchable` module extended into `SQLObject` class allows for dynamic `where` querying
- `Associatable` module defines `belongs_to` and `has_many` associations

## How to use ActiveRecordLite

- Download or clone this repository and include it in your project directory
- `require_relative ./MyActiveRecord/activerecordlite.rb`


Load your database:

```
DBConnection.open(db_file_name)
```
Under the hood, this will call:
```
SQLite3::Database.new(db_file_name)
```

#### Example Database:  "cats"
column name        | data type  | details
-------------------|------------|-----------------------
id                 | integer    | not null, primary key
name               | string     | not null, unique
owner_id           | integer    | not null


Define models by inheriting from `SQLObject`:
```
class Cat < SQLObject
end
```

By default, *ActiveRecordLite* will attempt to associate your sub-class to a table name by calling ActiveSupport's inflector method `tableize`.  You can override this by defining your own table name:

```
class Human < SQLObject
  self.table_name = "humans"

  finalize!
end
```

Call `finalize!` at the end of the class definition to create reader/writer methods:
```
class Cat < SQLObject
  self.finalize!
end

cat = Cat.new()
cat.name = "Bobbert"
cat.name #=> "Bobbert"
cat.id   #=> 1
```

You can also initialize models with attributes:
```
cat = cat.new(name: "Thomas", owner_id: 3)

cat.name     #=> "Thomas"
cat.owner_id #=> 3
```

#### Associations

Can be defined as you normally would:

```
class Cat < SQLObject
  belongs_to :human, :foreign_key => :owner_id
  has_one_through :home, :human, :house

  finalize!
end
```
