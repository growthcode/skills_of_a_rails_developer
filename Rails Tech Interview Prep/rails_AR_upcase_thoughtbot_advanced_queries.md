# Thoughtbot's Upcase.com _Advanced ActiveRecord Querying_

## Lesson 1: [Querying belongs_to Associations](https://upcase.com/videos/advanced-querying-belongs-to)
#### In this exercise, you'll be using ActiveRecord's join and merge methods to query your belongs_to associations in an object-oriented, composable way.

Association:

```ruby
  class Person < ActiveRecord::Base
    belongs_to :role
  end

  class Role < ActiveRecord::Base
    has_many :people
  end
```
```ruby
  class Role < ActiveRecord::Base
    def self.billable
      where(billable: true)
    end
  end

  Person.merge(Role.billable)
```

Gives us:

```sql
  PG:UndefinedTable: ERROR: missing FROM-clause entry for table "roles"
  LINE 1: SELECT * FROM "people" WHERE "roles"."billable" = 't'
                                       ^
  : SELECT * FROM "people" WHERE "roles"."billable" = 't'
```

You can see how only `people` table has been selected and yet `roles` are being referenced more easily when we write it as:

```sql
  SELECT *
  FROM "people"
  WHERE "roles"."billable" = 't'
```

You need the `joins(:role)` to add the `FROM` clause

__Note the pluralization of a `joins(...)`:__
  - Inside the `joins(...)`, pluralization depends on the association. Inside the `where(...)`, you put the table name of the joins reference.
  - example inside a belongs_to scope: `joins(:role).where(roles: {name: 'Manager'})`

__Think of `joins(...)` and `merge(...)` this way:__
  - `klass.joins(:ass_klass).where(ass_klasses: { condition: true} )` brings back `klass` records where the `ass_klass` search is true.
  - `klass.joins(:ass_klass).merge(ass_klass_scope(args))` replacing a `where(...)` with a `merge(...)` that uses an `ass_klass` class method (i.e. scope method) where conditions are already defined.
    - Allows you to take advantage of already written queries on other tables than the one you are on.
    - You still need the `joins(...)` so you can tell the query which table you are referencing in the association.

```ruby
  class Person < ActiveRecord::Base
    def self.billable
      joins(:role).merge(Role.billable)
    end
  end
```

Gives us:

```sql
  SELECT "people".*
  FROM "people"
  INNER JOIN "roles"
    ON "roles.id" = "people"."role_id"
  WHERE "roles"."billable" = 't';
```


## Lesson 2: [Querying belongs_to Associations](https://upcase.com/videos/advanced-querying-belongs-to)
#### Subqueries

```ruby
class Location < ActiveRecord::Base
  def self.billable
    joins(people: :role).where(roles: { billable: true }).distinct
  end

  def self.by_region_and_location_name
    joins(:region).merge(Region.order(:name)).order(:name)
  end
end
```

__This will fail:__

```ruby
Location.billable.by_region_and_location_name
```

Many time in DB queries you'll need to run subqueries before you can run secondary queries.

ActiveRecord generates a single query out of the methods you put on it. It doesn't assume anything. AR and DB has constraints to prevent problems.

One constraint is that you have to provide the ` ORDER BY ` fields you want to be main select statement.

When you use ` distinct `, it comes as ` SELECT DISTINCT `.

Order of operations issue... run the ` distinct ` query first, then the ` ORDER BY `

This is done with the AR ` .from(...) ` method.

__This will pass:__

```ruby
Location.from(Location.billable, :locations).by_region_and_location_name
```

